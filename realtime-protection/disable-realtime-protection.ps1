#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Disabling Real-time Protection..." -ForegroundColor Cyan
Write-Host ""
Write-Host "WARNING: This disables critical security features!" -ForegroundColor Red
Write-Host "WARNING: Tamper Protection must be OFF for this to work!" -ForegroundColor Red

$confirm = Read-Host "Type YES to confirm"
if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

$defenderPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
$rtpPath = "$defenderPath\Real-Time Protection"

# Create paths
if (-not (Test-Path $defenderPath)) {
    New-Item -Path $defenderPath -Force | Out-Null
}
if (-not (Test-Path $rtpPath)) {
    New-Item -Path $rtpPath -Force | Out-Null
}

Write-Host "[1/5] Disabling Real-time Monitoring..." -ForegroundColor Yellow
Set-ItemProperty -Path $rtpPath -Name "DisableRealtimeMonitoring" -Value 1 -Type DWord -Force

Write-Host "[2/5] Disabling Behavior Monitoring..." -ForegroundColor Yellow
Set-ItemProperty -Path $rtpPath -Name "DisableBehaviorMonitoring" -Value 1 -Type DWord -Force

Write-Host "[3/5] Disabling On-Access Protection..." -ForegroundColor Yellow
Set-ItemProperty -Path $rtpPath -Name "DisableOnAccessProtection" -Value 1 -Type DWord -Force

Write-Host "[4/5] Disabling Scan on Enable..." -ForegroundColor Yellow
Set-ItemProperty -Path $rtpPath -Name "DisableScanOnRealtimeEnable" -Value 1 -Type DWord -Force

Write-Host "[5/5] Disabling IOAV Protection..." -ForegroundColor Yellow
Set-ItemProperty -Path $rtpPath -Name "DisableIOAVProtection" -Value 1 -Type DWord -Force

Write-Host ""
Write-Host "Real-time Protection disabled." -ForegroundColor Red
Write-Host ""
Write-Host "NOTE: Settings may revert if Tamper Protection is enabled." -ForegroundColor Magenta
