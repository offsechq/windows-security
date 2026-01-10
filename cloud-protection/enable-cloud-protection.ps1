#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Enabling Cloud-Delivered Protection..." -ForegroundColor Cyan
Write-Host ""

$defenderPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
$spynetPath = "$defenderPath\Spynet"
$mpePath = "$defenderPath\MpEngine"

# Create paths
if (-not (Test-Path $defenderPath)) {
    New-Item -Path $defenderPath -Force | Out-Null
}
if (-not (Test-Path $spynetPath)) {
    New-Item -Path $spynetPath -Force | Out-Null
}
if (-not (Test-Path $mpePath)) {
    New-Item -Path $mpePath -Force | Out-Null
}

# Cloud Protection (MAPS)
Write-Host "[1/5] Enabling Cloud Protection (Advanced)..." -ForegroundColor Yellow
Set-ItemProperty -Path $spynetPath -Name "SpynetReporting" -Value 2 -Type DWord -Force

# Sample Submission
Write-Host "[2/5] Enabling Sample Submission (Safe samples)..." -ForegroundColor Yellow
Set-ItemProperty -Path $spynetPath -Name "SubmitSamplesConsent" -Value 1 -Type DWord -Force

# Block at First Sight
Write-Host "[3/5] Enabling Block at First Sight..." -ForegroundColor Yellow
Set-ItemProperty -Path $spynetPath -Name "DisableBlockAtFirstSeen" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

# Cloud Extended Timeout
Write-Host "[4/5] Setting Cloud Extended Timeout..." -ForegroundColor Yellow
Set-ItemProperty -Path $mpePath -Name "MpCloudBlockLevel" -Value 2 -Type DWord -Force

# PUA Protection
Write-Host "[5/5] Enabling PUA Protection..." -ForegroundColor Yellow
Set-ItemProperty -Path $defenderPath -Name "PUAProtection" -Value 1 -Type DWord -Force

Write-Host ""
Write-Host "Cloud-Delivered Protection enabled." -ForegroundColor Green
Write-Host ""
Write-Host "Features enabled:" -ForegroundColor Cyan
Write-Host "  - Cloud protection (Advanced)" -ForegroundColor Gray
Write-Host "  - Sample submission (Safe samples only)" -ForegroundColor Gray
Write-Host "  - Block at First Sight" -ForegroundColor Gray
Write-Host "  - PUA blocking" -ForegroundColor Gray
