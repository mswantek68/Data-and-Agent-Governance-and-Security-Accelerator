# Filename: 11-Enable-UnifiedAudit.ps1
param(
	[string]$UserPrincipalName
)

Import-Module ExchangeOnlineManagement -ErrorAction Stop

# Ensure TLS 1.2 for Exchange Online endpoints
try {
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} catch {
	# Ignore if not supported
}

if(-not (Get-Command Set-AdminAuditLogConfig -ErrorAction SilentlyContinue)){
	$connectParams = @{ ShowBanner = $false; CommandName = @('Get-AdminAuditLogConfig','Set-AdminAuditLogConfig') }
	if($UserPrincipalName){ $connectParams.UserPrincipalName = $UserPrincipalName }
	Connect-ExchangeOnline @connectParams | Out-Null
}

try {
	Connect-IPPSSession | Out-Null

	$cfg = Get-AdminAuditLogConfig
	if(-not $cfg.UnifiedAuditLogIngestionEnabled){
		Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true
		Write-Host "Unified Audit enabled" -ForegroundColor Green
	} else {
		Write-Host "Unified Audit already enabled" -ForegroundColor DarkGray
	}
} catch {
	$msg = $_.Exception.Message
	if ($msg -match 'SSL connection could not be established') {
		Write-Warning "Unified Audit step skipped due to SSL/TLS connection failure. Verify outbound HTTPS access and TLS 1.2 support, then re-run this step."
		return
	}
	throw
}