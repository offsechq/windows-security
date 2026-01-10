#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Disabling Network Protection..." -ForegroundColor Cyan
Write-Host ""
Write-Host "WARNING: This disables important security features!" -ForegroundColor Red

$confirm = Read-Host "Type YES to confirm"
if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

$npPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection"
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection"

Write-Host "[1/2] Disabling Network Protection..." -ForegroundColor Yellow
if (Test-Path $npPath) {
    Set-ItemProperty -Path $npPath -Name "EnableNetworkProtection" -Value 0 -Type DWord -Force
}

Write-Host "[2/2] Removing policy..." -ForegroundColor Yellow
if (Test-Path $policyPath) {
    Set-ItemProperty -Path $policyPath -Name "EnableNetworkProtection" -Value 0 -Type DWord -Force
}

Write-Host ""
Write-Host "Network Protection disabled." -ForegroundColor Red
