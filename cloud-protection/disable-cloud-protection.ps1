#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Disabling Cloud-Delivered Protection..." -ForegroundColor Cyan
Write-Host ""
Write-Host "WARNING: This reduces malware detection capabilities!" -ForegroundColor Red

$confirm = Read-Host "Type YES to confirm"
if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

$defenderPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
$spynetPath = "$defenderPath\Spynet"
$mpePath = "$defenderPath\MpEngine"

# Disable Cloud Protection
Write-Host "[1/5] Disabling Cloud Protection..." -ForegroundColor Yellow
if (Test-Path $spynetPath) {
    Set-ItemProperty -Path $spynetPath -Name "SpynetReporting" -Value 0 -Type DWord -Force
}

# Disable Sample Submission
Write-Host "[2/5] Disabling Sample Submission..." -ForegroundColor Yellow
if (Test-Path $spynetPath) {
    Set-ItemProperty -Path $spynetPath -Name "SubmitSamplesConsent" -Value 2 -Type DWord -Force
}

# Disable Block at First Sight
Write-Host "[3/5] Disabling Block at First Sight..." -ForegroundColor Yellow
if (Test-Path $spynetPath) {
    Set-ItemProperty -Path $spynetPath -Name "DisableBlockAtFirstSeen" -Value 1 -Type DWord -Force
}

# Remove Cloud settings
Write-Host "[4/5] Removing Cloud Block Level..." -ForegroundColor Yellow
if (Test-Path $mpePath) {
    Remove-ItemProperty -Path $mpePath -Name "MpCloudBlockLevel" -ErrorAction SilentlyContinue
}

# Disable PUA Protection
Write-Host "[5/5] Disabling PUA Protection..." -ForegroundColor Yellow
if (Test-Path $defenderPath) {
    Set-ItemProperty -Path $defenderPath -Name "PUAProtection" -Value 0 -Type DWord -Force
}

Write-Host ""
Write-Host "Cloud-Delivered Protection disabled." -ForegroundColor Red
