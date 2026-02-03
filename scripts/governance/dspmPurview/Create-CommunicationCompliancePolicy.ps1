# Filename: 33-Create-CommunicationCompliancePolicy.ps1
param([Parameter(Mandatory=$true)][string]$SpecPath)

$spec = Get-Content $SpecPath -Raw | ConvertFrom-Json

Import-Module ExchangeOnlineManagement -ErrorAction Stop
Connect-IPPSSession | Out-Null

if(-not (Get-Command New-CommunicationCompliancePolicy -ErrorAction SilentlyContinue)){
  Write-Host "Communication Compliance cmdlets not available in this environment; skipping policy creation." -ForegroundColor Yellow
  return
}

function Get-SpecCcPolicies {
  param([object]$specObject)
  if($specObject.PSObject.Properties.Match('communicationCompliancePolicies') -and $specObject.communicationCompliancePolicies){ return $specObject.communicationCompliancePolicies }
  return @()
}

$policies = Get-SpecCcPolicies -specObject $spec
if(-not $policies -or $policies.Count -eq 0){
  Write-Host "No communication compliance policies defined; skipping." -ForegroundColor Yellow
  return
}

foreach($policy in $policies){
  $name = $policy.name
  if([string]::IsNullOrWhiteSpace($name)){
    Write-Host "Skipping unnamed communication compliance policy entry." -ForegroundColor Yellow
    continue
  }

  $reviewers = $policy.reviewers
  if(-not $reviewers -or $reviewers.Count -eq 0){
    Write-Host "Policy '$name' has no reviewers defined; unable to create Communication Compliance policy. Add 'reviewers' UPNs or groups to the spec." -ForegroundColor Yellow
    continue
  }

  $comment = $policy.comment
  $enabled = $true
  if($policy.PSObject.Properties.Match('enabled')){ $enabled = [bool]$policy.enabled }

  $existing = Get-CommunicationCompliancePolicy -Identity $name -ErrorAction SilentlyContinue
  if(-not $existing){
    $params = @{ Name = $name; Reviewers = $reviewers; Confirm = $false }
    if($comment){ $params['Description'] = $comment }
    New-CommunicationCompliancePolicy @params | Out-Null
    Write-Host "Created communication compliance policy $name" -ForegroundColor Green
  } else {
    $setParams = @{ Identity = $name; Reviewers = $reviewers; Confirm = $false }
    if($comment){ $setParams['Description'] = $comment }
    Set-CommunicationCompliancePolicy @setParams | Out-Null
    Write-Host "Updated communication compliance policy $name" -ForegroundColor Cyan
  }

  if(-not (Get-Command Set-CommunicationCompliancePolicy -ErrorAction SilentlyContinue)){
    Write-Host "Set-CommunicationCompliancePolicy cmdlet missing; cannot toggle enablement for '$name'." -ForegroundColor Yellow
  } else {
    try {
      Set-CommunicationCompliancePolicy -Identity $name -Enabled:$enabled -Confirm:$false | Out-Null
    } catch {
      Write-Host "Failed to set enabled state for '$name': $($_.Exception.Message)" -ForegroundColor Yellow
    }
  }
}

Write-Host "Communication compliance policies processed." -ForegroundColor Cyan