# Filename: 12-Create-DlpPolicy.ps1
param([Parameter(Mandatory=$true)][string]$SpecPath)
$spec = Get-Content $SpecPath -Raw | ConvertFrom-Json
Import-Module ExchangeOnlineManagement -ErrorAction Stop
Connect-IPPSSession | Out-Null

$modeMap = @{
  "Enforce" = "Enable"
  "Enable" = "Enable"
  "TestWithNotifications" = "TestWithNotifications"
  "TestWithoutNotifications" = "TestWithoutNotifications"
  "Disable" = "Disable"
}

$locationParamMap = @{
  Exchange  = "ExchangeLocation"
  SharePoint = "SharePointLocation"
  OneDrive  = "OneDriveLocation"
  Teams     = "TeamsLocation"
  Endpoint  = "EndpointDlpLocation"
}

$newPolicyCmd = Get-Command New-DlpCompliancePolicy -ErrorAction Stop
$setPolicyCmd = Get-Command Set-DlpCompliancePolicy -ErrorAction Stop

function Get-SpecDlpPolicies {
  param([object]$specObject)
  if($specObject.PSObject.Properties.Match('dlpPolicies') -and $specObject.dlpPolicies){ return $specObject.dlpPolicies }
  if($specObject.PSObject.Properties.Match('dlpPolicy') -and $specObject.dlpPolicy){ return @($specObject.dlpPolicy) }
  return @()
}

function Normalize-LocationValue {
  param($value)
  if($null -eq $value){ return $null }
  if($value -is [string]){ return $value }
  if($value -is [System.Collections.IEnumerable]){ return @($value) }
  return $value
}

$policies = Get-SpecDlpPolicies -specObject $spec
if(-not $policies -or $policies.Count -eq 0){
  Write-Host "No DLP policies defined in spec; skipping." -ForegroundColor Yellow
  return
}

$sitCache = @{}
function Resolve-SensitiveInfoType([string]$name){
  if($sitCache.ContainsKey($name)){ return $sitCache[$name] }
  $type = Get-DlpSensitiveInformationType -Identity $name -ErrorAction SilentlyContinue
  if(-not $type){ $type = Get-DlpSensitiveInformationType | Where-Object Name -eq $name }
  if(-not $type){ throw "Sensitive information type '$name' not found in tenant." }
  $sitCache[$name] = $type
  return $type
}

function ConvertTo-ConfidenceLevel($value){
  if($null -eq $value){ return $null }
  if(($value -is [string]) -and [string]::IsNullOrWhiteSpace($value)){ return $null }
  $normalized = $value
  if($value -isnot [string]){ $normalized = [string][int]$value }
  $normalized = $normalized.Trim()
  switch -Regex ($normalized){
    '^(high)$'   { return 'High' }
    '^(medium)$' { return 'Medium' }
    '^(low)$'    { return 'Low' }
  }
  $intValue = 0
  if(-not [int]::TryParse($normalized,[ref]$intValue)){ return $null }
  if($intValue -ge 85){ return 'High' }
  elseif($intValue -ge 65){ return 'Medium' }
  return 'Low'
}

foreach($policy in $policies){
  $dlpName = $policy.name
  if([string]::IsNullOrWhiteSpace($dlpName)){
    Write-Host "Skipping unnamed DLP policy entry." -ForegroundColor Yellow
    continue
  }

  $mode = $policy.mode
  $modeValue = if([string]::IsNullOrWhiteSpace($mode)){ "Enable" } elseif($modeMap.ContainsKey($mode)){ $modeMap[$mode] } else { $mode }

  $createParams = @{ Name = $dlpName; Mode = $modeValue }
  $setParams = @{ Identity = $dlpName; Mode = $modeValue }
  if($policy.comment){
    $createParams['Comment'] = $policy.comment
    $setParams['Comment'] = $policy.comment
  }

  $loc = $policy.locations
  $unsupported = @()
  foreach($key in $locationParamMap.Keys){
    if($loc -and $loc.PSObject.Properties.Match($key)){
      $val = Normalize-LocationValue -value $loc.$key
      $paramName = $locationParamMap[$key]
      if($newPolicyCmd.Parameters.ContainsKey($paramName)){
        if($null -ne $val){
          $createParams[$paramName] = $val
          $setParams[$paramName] = $val
        }
      } else {
        $unsupported += "$key locations (module version missing $paramName)"
      }
    }
  }

  if($policy.PSObject.Properties.Match('enforcementPlanes') -and $policy.enforcementPlanes){
    $unsupported += "enforcementPlanes (Browser/Application scopes not automated yet)"
  }
  if($policy.PSObject.Properties.Match('locationsRaw') -and $policy.locationsRaw){
    $unsupported += "locationsRaw (modern workload locations not applied)"
  }
  if($unsupported.Count -gt 0){
    Write-Host "Policy '$dlpName' includes unsupported fields: $($unsupported -join ', '). These are not applied." -ForegroundColor Yellow
  }

  $existingPolicy = Get-DlpCompliancePolicy -Identity $dlpName -ErrorAction SilentlyContinue
  if(-not $existingPolicy){
    New-DlpCompliancePolicy @createParams | Out-Null
    Write-Host "Created DLP policy $dlpName" -ForegroundColor Green
  } else {
    Set-DlpCompliancePolicy @setParams | Out-Null
    Write-Host "Updated DLP policy $dlpName" -ForegroundColor Cyan
  }

  if(-not $policy.rules -or $policy.rules.Count -eq 0){
    Write-Host "No rules provided for policy '$dlpName'; skipping rule creation." -ForegroundColor Yellow
    continue
  }

  foreach($r in $policy.rules){
    $ruleName = $r.name
    if([string]::IsNullOrWhiteSpace($ruleName)){
      Write-Host "Skipping unnamed DLP rule in policy '$dlpName'." -ForegroundColor Yellow
      continue
    }
    if($r.PSObject.Properties.Match('sensitivityLabels') -and $r.sensitivityLabels){
      Write-Host "Rule '$ruleName' in policy '$dlpName' includes sensitivityLabels; label-based enforcement isn't automated yet and will be skipped." -ForegroundColor Yellow
    }
    $sit = @()
    foreach($t in $r.sensitiveInfoTypes){
      $type = Resolve-SensitiveInfoType -name $t.name
      $entry = @{ Name = $type.Name }
      $labelId = $null
      if($type.PSObject.Properties.Match('ImmutableId') -and $type.ImmutableId){ $labelId = $type.ImmutableId }
      elseif($type.PSObject.Properties.Match('Id') -and $type.Id){ $labelId = $type.Id }
      elseif($type.PSObject.Properties.Match('Identity') -and $type.Identity){ $labelId = $type.Identity }
      if($labelId){ $entry['Id'] = $labelId.ToString() }
      if($t.count){ $entry['minCount'] = [string][int]$t.count }
      $confidenceLevel = ConvertTo-ConfidenceLevel -value $t.confidence
      if($confidenceLevel){ $entry['confidencelevel'] = $confidenceLevel }
      $sit += $entry
    }

    if(-not (Get-DlpComplianceRule -Policy $dlpName -ErrorAction SilentlyContinue | Where-Object Name -eq $ruleName)){
      $params = @{
        Name = $ruleName
        Policy = $dlpName
        ContentContainsSensitiveInformation = $sit
        BlockAccess = [bool]$r.blockAccess
      }
      if($r.notifyUser){ Write-Host "NotifyUser requested for $ruleName. Configure notification settings manually until automated support ships." -ForegroundColor Yellow }
      New-DlpComplianceRule @params | Out-Null
      Write-Host "Created DLP rule $ruleName" -ForegroundColor Green
    } else {
      Write-Host "DLP rule exists: $ruleName" -ForegroundColor DarkGray
    }
  }
}
