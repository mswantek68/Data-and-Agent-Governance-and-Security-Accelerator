# Filename: 28-Ensure-PurviewCollectionsForFabricWorkspaces.ps1
param([Parameter(Mandatory=$true)][string]$SpecPath)

$ErrorActionPreference = 'Stop'
$spec = Get-Content $SpecPath -Raw | ConvertFrom-Json
$ensureContextPath = Join-Path $PSScriptRoot "..\..\common\Ensure-AzContext.ps1"
. $ensureContextPath
Import-Module Az.Accounts -ErrorAction Stop
Ensure-AzContext -TenantId $spec.tenantId -SubscriptionId $spec.subscriptionId

if(-not $spec.purviewAccount){
  Write-Host "purviewAccount is not configured in spec. Skipping Purview collection setup for Fabric workspaces." -ForegroundColor Yellow
  exit 0
}

$workspaces = @()
if($spec.fabric -and $spec.fabric.workspaces){
  $workspaces = @($spec.fabric.workspaces)
}
if($workspaces.Count -eq 0){
  Write-Host "No fabric.workspaces entries found. Skipping Purview collection setup." -ForegroundColor DarkGray
  exit 0
}

function Get-OptionalStringProperty($obj, [string]$name){
  if(-not $obj){ return $null }
  $prop = $obj.PSObject.Properties[$name]
  if($null -eq $prop -or $null -eq $prop.Value){ return $null }
  return [string]$prop.Value
}

function Get-AccessTokenForResource([string]$resourceUrl){
  try {
    $token = az account get-access-token --resource $resourceUrl --query accessToken -o tsv 2>$null
    if($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($token)){
      return $token.Trim()
    }
  } catch {
  }

  try {
    return (Get-AzAccessToken -ResourceUrl $resourceUrl).Token
  } catch {
    return $null
  }
}

function Get-PvToken {
  $token = Get-AccessTokenForResource -resourceUrl "https://purview.azure.net"
  if([string]::IsNullOrWhiteSpace($token)){
    $token = Get-AccessTokenForResource -resourceUrl "https://purview.azure.com"
  }
  return $token
}

function PvInvoke([string]$method,[string]$path,[object]$body){
  $uri = "https://$($spec.purviewAccount).purview.azure.com$path"
  $pvToken = Get-PvToken
  if([string]::IsNullOrWhiteSpace($pvToken)){
    throw "Failed to acquire Purview access token. Run az login and verify Purview data-plane access."
  }
  $headers = @{ Authorization = "Bearer $pvToken"; "Content-Type" = "application/json" }
  $payload = if($body){ $body | ConvertTo-Json -Depth 20 } else { $null }
  Invoke-RestMethod -Method $method -Uri $uri -Headers $headers -Body $payload
}

$existingCollections = @()
try {
  $existingResult = PvInvoke 'GET' '/account/collections?api-version=2019-11-01-preview' $null
  if($existingResult.value){
    $existingCollections = @($existingResult.value)
  }
} catch {
  Write-Host "Failed to enumerate existing Purview collections: $($_.Exception.Message)" -ForegroundColor Yellow
  exit 0
}

$collectionMap = @()
foreach($workspace in $workspaces){
  $workspaceName = Get-OptionalStringProperty -obj $workspace -name 'name'
  if([string]::IsNullOrWhiteSpace($workspaceName)){
    Write-Host "Skipping collection setup for Fabric workspace entry with empty name." -ForegroundColor Yellow
    continue
  }

  $existing = @($existingCollections | Where-Object { $_.friendlyName -eq $workspaceName -or $_.name -eq $workspaceName } | Select-Object -First 1)
  if($existing.Count -gt 0){
    $collectionId = [string]$existing[0].name
    Write-Host "Purview collection '$workspaceName' already exists (id=$collectionId)." -ForegroundColor DarkGray
  } else {
    try {
      $payload = @{ friendlyName = $workspaceName; description = "Collection for Fabric workspace $workspaceName" }
      $created = PvInvoke 'PUT' "/account/collections/$([System.Uri]::EscapeDataString($workspaceName))?api-version=2019-11-01-preview" $payload
      $collectionId = [string]$created.name
      Write-Host "Created Purview collection '$workspaceName' (id=$collectionId)." -ForegroundColor Green
      $existingCollections += $created
    } catch {
      Write-Host "Failed to create Purview collection for workspace '${workspaceName}': $($_.Exception.Message)" -ForegroundColor Yellow
      continue
    }
  }

  if(-not [string]::IsNullOrWhiteSpace($collectionId)){
    $collectionMap += [pscustomobject]@{
      workspaceName = $workspaceName
      collectionId = $collectionId
      collectionName = $workspaceName
    }
  }
}

if($collectionMap.Count -gt 0){
  $tempDir = [IO.Path]::GetTempPath()
  if(-not (Test-Path -LiteralPath $tempDir)){ New-Item -ItemType Directory -Path $tempDir -Force | Out-Null }
  $mapPath = Join-Path $tempDir 'fabric_purview_collections.json'
  $collectionMap | ConvertTo-Json -Depth 10 | Set-Content -Path $mapPath -Encoding UTF8
  Write-Host "Saved Fabric-Purview collection map to $mapPath" -ForegroundColor DarkGray
}
