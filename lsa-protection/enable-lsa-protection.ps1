#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Enabling LSA Protection (PPL)..." -ForegroundColor Cyan
Write-Host ""

$lsaPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"

# Enable RunAsPPL
Write-Host "[1/2] Setting RunAsPPL..." -ForegroundColor Yellow
Set-ItemProperty -Path $lsaPath -Name "RunAsPPL" -Value 1 -Type DWord -Force

# Configure audit mode for incompatible drivers (optional)
Write-Host "[2/2] Enabling audit mode for troubleshooting..." -ForegroundColor Yellow
Set-ItemProperty -Path $lsaPath -Name "RunAsPPLBoot" -Value 2 -Type DWord -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "LSA Protection enabled." -ForegroundColor Green
Write-Host ""
Write-Host "NOTE: Check Event Viewer > Windows Logs > System for LSA events." -ForegroundColor Magenta
Write-Host "Event ID 3033 = Driver blocked (incompatible)" -ForegroundColor Gray
Write-Host "Event ID 3063 = Driver load attempt blocked" -ForegroundColor Gray
Write-Host ""
Write-Host "RESTART REQUIRED" -ForegroundColor Yellow
