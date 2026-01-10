#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Disabling SmartScreen..." -ForegroundColor Cyan
Write-Host ""
Write-Host "WARNING: This disables important security features!" -ForegroundColor Red

$confirm = Read-Host "Type YES to confirm"
if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

# Explorer SmartScreen
Write-Host "[1/4] Disabling Explorer SmartScreen..." -ForegroundColor Yellow
$explorerPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
Set-ItemProperty -Path $explorerPath -Name "SmartScreenEnabled" -Value "Off" -Type String -Force

# Policy SmartScreen
Write-Host "[2/4] Disabling SmartScreen policy..." -ForegroundColor Yellow
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
if (Test-Path $policyPath) {
    Set-ItemProperty -Path $policyPath -Name "EnableSmartScreen" -Value 0 -Type DWord -Force
    Remove-ItemProperty -Path $policyPath -Name "ShellSmartScreenLevel" -ErrorAction SilentlyContinue
}

# Edge SmartScreen
Write-Host "[3/4] Disabling Edge SmartScreen..." -ForegroundColor Yellow
$edgePath = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter"
if (Test-Path $edgePath) {
    Set-ItemProperty -Path $edgePath -Name "EnabledV9" -Value 0 -Type DWord -Force
}

# Store Apps SmartScreen
Write-Host "[4/4] Disabling Store Apps SmartScreen..." -ForegroundColor Yellow
$appHostPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost"
if (Test-Path $appHostPath) {
    Set-ItemProperty -Path $appHostPath -Name "EnableWebContentEvaluation" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "SmartScreen disabled." -ForegroundColor Red
