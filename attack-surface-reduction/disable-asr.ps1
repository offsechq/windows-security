#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Disabling Attack Surface Reduction Rules..." -ForegroundColor Cyan
Write-Host ""
Write-Host "WARNING: This disables important security features!" -ForegroundColor Red

$confirm = Read-Host "Type YES to confirm"
if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

$asrPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR"
$rulesPath = "$asrPath\Rules"

# Disable ASR feature
if (Test-Path $asrPath) {
    Write-Host "[1/2] Disabling ASR feature..." -ForegroundColor Yellow
    Set-ItemProperty -Path $asrPath -Name "ExploitGuard_ASR_Rules" -Value 0 -Type DWord -Force
}

# Remove all rule configurations
if (Test-Path $rulesPath) {
    Write-Host "[2/2] Removing ASR rule configurations..." -ForegroundColor Yellow
    Remove-Item -Path $rulesPath -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "ASR rules disabled." -ForegroundColor Red
Write-Host ""
Write-Host "RESTART RECOMMENDED" -ForegroundColor Yellow
