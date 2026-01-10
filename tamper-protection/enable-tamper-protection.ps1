#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Enabling Tamper Protection..." -ForegroundColor Cyan
Write-Host ""

$featuresPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"

if (-not (Test-Path $featuresPath)) {
    Write-Host "ERROR: Windows Defender Features path not found." -ForegroundColor Red
    Write-Host "Windows Defender may not be installed or active." -ForegroundColor Yellow
    exit 1
}

Write-Host "[1/1] Setting Tamper Protection..." -ForegroundColor Yellow

try {
    Set-ItemProperty -Path $featuresPath -Name "TamperProtection" -Value 5 -Type DWord -Force -ErrorAction Stop
    Write-Host ""
    Write-Host "Tamper Protection enabled." -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "ERROR: Failed to enable Tamper Protection via registry." -ForegroundColor Red
    Write-Host "This is expected - Tamper Protection is typically managed via:" -ForegroundColor Yellow
    Write-Host "  - Windows Security > Virus & threat protection > Manage settings" -ForegroundColor Gray
    Write-Host "  - Microsoft Defender for Endpoint (enterprise)" -ForegroundColor Gray
    Write-Host "  - Microsoft Intune" -ForegroundColor Gray
}
