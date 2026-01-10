#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Enabling SmartScreen..." -ForegroundColor Cyan
Write-Host ""

# Explorer SmartScreen
Write-Host "[1/4] Setting Explorer SmartScreen..." -ForegroundColor Yellow
$explorerPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
Set-ItemProperty -Path $explorerPath -Name "SmartScreenEnabled" -Value "Block" -Type String -Force

# Policy SmartScreen
Write-Host "[2/4] Setting SmartScreen policy..." -ForegroundColor Yellow
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
if (-not (Test-Path $policyPath)) {
    New-Item -Path $policyPath -Force | Out-Null
}
Set-ItemProperty -Path $policyPath -Name "EnableSmartScreen" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $policyPath -Name "ShellSmartScreenLevel" -Value "Block" -Type String -Force

# Edge SmartScreen
Write-Host "[3/4] Setting Edge SmartScreen..." -ForegroundColor Yellow
$edgePath = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter"
if (-not (Test-Path $edgePath)) {
    New-Item -Path $edgePath -Force | Out-Null
}
Set-ItemProperty -Path $edgePath -Name "EnabledV9" -Value 1 -Type DWord -Force

# Store Apps SmartScreen
Write-Host "[4/4] Setting Store Apps SmartScreen..." -ForegroundColor Yellow
$appHostPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost"
if (Test-Path $appHostPath) {
    Set-ItemProperty -Path $appHostPath -Name "EnableWebContentEvaluation" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "SmartScreen enabled in Block mode." -ForegroundColor Green
