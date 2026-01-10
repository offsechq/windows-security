#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Disabling Tamper Protection..." -ForegroundColor Cyan
Write-Host ""
Write-Host "WARNING: This attempts to disable Tamper Protection!" -ForegroundColor Red
Write-Host "WARNING: This may fail if Tamper Protection is active!" -ForegroundColor Red
Write-Host ""
Write-Host "For reliable disable, use Windows Security UI:" -ForegroundColor Yellow
Write-Host "  Settings > Privacy & security > Windows Security" -ForegroundColor Gray
Write-Host "  > Virus & threat protection > Manage settings" -ForegroundColor Gray
Write-Host "  > Toggle off Tamper Protection" -ForegroundColor Gray
Write-Host ""

$confirm = Read-Host "Type YES to attempt registry disable"
if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

$featuresPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"

if (-not (Test-Path $featuresPath)) {
    Write-Host "ERROR: Windows Defender Features path not found." -ForegroundColor Red
    exit 1
}

Write-Host "[1/1] Attempting to disable Tamper Protection..." -ForegroundColor Yellow

try {
    # Try setting to 0 (disabled) or 4 (disabled alternative)
    Set-ItemProperty -Path $featuresPath -Name "TamperProtection" -Value 0 -Type DWord -Force -ErrorAction Stop
    Write-Host ""
    Write-Host "Tamper Protection registry value set to disabled." -ForegroundColor Green
    Write-Host ""
    Write-Host "NOTE: Verify in Windows Security that it's actually disabled." -ForegroundColor Magenta
} catch {
    Write-Host ""
    Write-Host "ERROR: Cannot modify Tamper Protection via registry." -ForegroundColor Red
    Write-Host "This is expected - Tamper Protection is blocking changes." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To disable Tamper Protection:" -ForegroundColor Cyan
    Write-Host "1. Open Windows Security" -ForegroundColor Gray
    Write-Host "2. Go to Virus & threat protection" -ForegroundColor Gray
    Write-Host "3. Click 'Manage settings'" -ForegroundColor Gray
    Write-Host "4. Toggle off 'Tamper Protection'" -ForegroundColor Gray
    Write-Host "5. Then re-run this script or other Defender scripts" -ForegroundColor Gray
}
