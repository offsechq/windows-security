#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Enabling Real-time Protection..." -ForegroundColor Cyan
Write-Host ""

$defenderPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
$rtpPath = "$defenderPath\Real-Time Protection"

# Enable Defender
Write-Host "[1/5] Enabling Windows Defender..." -ForegroundColor Yellow
if (-not (Test-Path $defenderPath)) {
    New-Item -Path $defenderPath -Force | Out-Null
}
Remove-ItemProperty -Path $defenderPath -Name "DisableAntiSpyware" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path $defenderPath -Name "DisableAntiVirus" -ErrorAction SilentlyContinue

# Enable Real-time Protection
Write-Host "[2/5] Enabling Real-time Monitoring..." -ForegroundColor Yellow
if (-not (Test-Path $rtpPath)) {
    New-Item -Path $rtpPath -Force | Out-Null
}
Remove-ItemProperty -Path $rtpPath -Name "DisableRealtimeMonitoring" -ErrorAction SilentlyContinue

Write-Host "[3/5] Enabling Behavior Monitoring..." -ForegroundColor Yellow
Remove-ItemProperty -Path $rtpPath -Name "DisableBehaviorMonitoring" -ErrorAction SilentlyContinue

Write-Host "[4/5] Enabling On-Access Protection..." -ForegroundColor Yellow
Remove-ItemProperty -Path $rtpPath -Name "DisableOnAccessProtection" -ErrorAction SilentlyContinue

Write-Host "[5/5] Enabling Scan on Enable..." -ForegroundColor Yellow
Remove-ItemProperty -Path $rtpPath -Name "DisableScanOnRealtimeEnable" -ErrorAction SilentlyContinue

# Remove empty key if no values remain
$rtpKey = Get-Item -Path $rtpPath -ErrorAction SilentlyContinue
if ($rtpKey -and $rtpKey.ValueCount -eq 0) {
    Remove-Item -Path $rtpPath -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Real-time Protection enabled." -ForegroundColor Green
Write-Host ""
Write-Host "NOTE: Tamper Protection may override these settings if active." -ForegroundColor Magenta
