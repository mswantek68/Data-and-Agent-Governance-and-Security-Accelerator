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

function Get-LocationValue {
  param([object]$locationObject,[string]$name)
  if($null -eq $locationObject){ return $null }
  $prop = $locationObject.PSObject.Properties[$name]
  if($null -eq $prop){ return $null }
  return $prop.Value
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
  foreach($key in $locationParamMap.Keys){
    if($loc -and $loc.PSObject.Properties.Match($key)){
      $rawValue = Get-LocationValue -locationObject $loc -name $key
      if($null -eq $rawValue){ continue }
      $val = Normalize-LocationValue -value $rawValue
      $paramName = $locationParamMap[$key]
      $canCreate = $newPolicyCmd.Parameters.ContainsKey($paramName)
      $canUpdate = $setPolicyCmd.Parameters.ContainsKey($paramName)
      if(-not $canCreate -and -not $canUpdate){
        Write-Host "DLP location '$key' not supported by current module; skipping." -ForegroundColor Yellow
        continue
      }
      if($null -ne $val){
        if($canCreate){ $createParams[$paramName] = $val }
        if($canUpdate){ $setParams[$paramName] = $val }
      }
    }
  }

  # Remove null entries before calling cmdlets
  foreach($key in @($createParams.Keys)) { if($null -eq $createParams[$key]) { $createParams.Remove($key) } }
  foreach($key in @($setParams.Keys)) { if($null -eq $setParams[$key]) { $setParams.Remove($key) } }

  if(-not (Get-DlpCompliancePolicy -Identity $dlpName -ErrorAction SilentlyContinue)){
    try {
      New-DlpCompliancePolicy @createParams | Out-Null
      Write-Host "Created DLP policy $dlpName" -ForegroundColor Green
    } catch {
      $message = $_.Exception.Message
      if ($message -match 'CompliancePolicyAlreadyExistsInScenarioException' -or $message -match 'already exists') {
        try {
          Set-DlpCompliancePolicy @setParams | Out-Null
          Write-Host "Updated DLP policy $dlpName" -ForegroundColor DarkGray
        } catch {
          # Retry with minimal parameters if location updates are unsupported
          $minimalParams = @{ Identity = $dlpName }
          if($setParams.ContainsKey('Mode')) { $minimalParams['Mode'] = $setParams['Mode'] }
          if($setParams.ContainsKey('Comment')) { $minimalParams['Comment'] = $setParams['Comment'] }
          Set-DlpCompliancePolicy @minimalParams | Out-Null
          Write-Host "Updated DLP policy $dlpName (minimal)" -ForegroundColor DarkGray
        }
      } else {
        throw
      }
    }
  } else {
    try {
      Set-DlpCompliancePolicy @setParams | Out-Null
      Write-Host "Updated DLP policy $dlpName" -ForegroundColor DarkGray
    } catch {
      $minimalParams = @{ Identity = $dlpName }
      if($setParams.ContainsKey('Mode')) { $minimalParams['Mode'] = $setParams['Mode'] }
      if($setParams.ContainsKey('Comment')) { $minimalParams['Comment'] = $setParams['Comment'] }
      Set-DlpCompliancePolicy @minimalParams | Out-Null
      Write-Host "Updated DLP policy $dlpName (minimal)" -ForegroundColor DarkGray
    }
  }

  foreach($r in $policy.rules){
    $ruleName = $r.name
    if([string]::IsNullOrWhiteSpace($ruleName)){
      Write-Host "Skipping unnamed DLP rule in policy $dlpName." -ForegroundColor Yellow
      continue
    }
    $sit = @()
    foreach($t in $r.sensitiveInfoTypes){
      $type = Resolve-SensitiveInfoType -name $t.name
      $entry = @{ Name = $type.Name }
      $labelId = $null
      $immutableProp = $type.PSObject.Properties['ImmutableId']
      if($immutableProp -and $immutableProp.Value){ $labelId = $immutableProp.Value }
      if(-not $labelId){
        $idProp = $type.PSObject.Properties['Id']
        if($idProp -and $idProp.Value){ $labelId = $idProp.Value }
      }
      if(-not $labelId){
        $identityProp = $type.PSObject.Properties['Identity']
        if($identityProp -and $identityProp.Value){ $labelId = $identityProp.Value }
      }
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
