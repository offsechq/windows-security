#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Enabling Network Protection..." -ForegroundColor Cyan
Write-Host ""

# Registry paths
$npPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection"
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection"

# Create paths if they don't exist
if (-not (Test-Path $npPath)) {
    New-Item -Path $npPath -Force | Out-Null
}
if (-not (Test-Path $policyPath)) {
    New-Item -Path $policyPath -Force | Out-Null
}

Write-Host "[1/2] Setting Network Protection to Block mode..." -ForegroundColor Yellow
Set-ItemProperty -Path $npPath -Name "EnableNetworkProtection" -Value 1 -Type DWord -Force

Write-Host "[2/2] Setting policy..." -ForegroundColor Yellow
Set-ItemProperty -Path $policyPath -Name "EnableNetworkProtection" -Value 1 -Type DWord -Force

# For Windows Server environments
$serverPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection"
if (Test-Path $serverPath) {
    Set-ItemProperty -Path $serverPath -Name "AllowNetworkProtectionOnWinServer" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $serverPath -Name "AllowNetworkProtectionDownLevel" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Network Protection enabled." -ForegroundColor Green
Write-Host ""
Write-Host "NOTE: Requires Windows Defender to be active." -ForegroundColor Magenta
