# Filename: 34-Create-InsiderRiskPolicy.ps1
param([Parameter(Mandatory=$true)][string]$SpecPath)

$spec = Get-Content $SpecPath -Raw | ConvertFrom-Json

Import-Module ExchangeOnlineManagement -ErrorAction Stop
Connect-IPPSSession | Out-Null

if(-not (Get-Command Get-InsiderRiskPolicy -ErrorAction SilentlyContinue)){
  Write-Host "Insider Risk Management cmdlets not available; skipping insider risk policy creation." -ForegroundColor Yellow
  return
}

function Get-SpecIrmPolicies {
  param([object]$specObject)
  if($specObject.PSObject.Properties.Match('insiderRiskPolicies') -and $specObject.insiderRiskPolicies){ return $specObject.insiderRiskPolicies }
  return @()
}

$policies = Get-SpecIrmPolicies -specObject $spec
if(-not $policies -or $policies.Count -eq 0){
  Write-Host "No insider risk policies defined; skipping." -ForegroundColor Yellow
  return
}

foreach($policy in $policies){
  $name = $policy.name
  if([string]::IsNullOrWhiteSpace($name)){
    Write-Host "Skipping unnamed insider risk policy entry." -ForegroundColor Yellow
    continue
  }

  # Current automation is a placeholder; create/update is not exposed in public PowerShell. Log intent for operators.
  Write-Host "Insider Risk policy '$name' is specified in the spec but automated creation is not supported by available cmdlets. Configure this policy manually in the portal." -ForegroundColor Yellow
}

Write-Host "Insider risk policies inspected (no automation performed)." -ForegroundColor Cyan