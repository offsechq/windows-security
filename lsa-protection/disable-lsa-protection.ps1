#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Disabling LSA Protection (PPL)..." -ForegroundColor Cyan
Write-Host ""
Write-Host "WARNING: This weakens credential protection!" -ForegroundColor Red
Write-Host "WARNING: System will be vulnerable to credential theft attacks!" -ForegroundColor Red

$confirm = Read-Host "Type YES to confirm"
if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

$lsaPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"

Write-Host "[1/2] Removing RunAsPPL..." -ForegroundColor Yellow
Set-ItemProperty -Path $lsaPath -Name "RunAsPPL" -Value 0 -Type DWord -Force

Write-Host "[2/2] Removing RunAsPPLBoot..." -ForegroundColor Yellow
Remove-ItemProperty -Path $lsaPath -Name "RunAsPPLBoot" -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "LSA Protection disabled." -ForegroundColor Red
Write-Host ""
Write-Host "RESTART REQUIRED" -ForegroundColor Yellow
