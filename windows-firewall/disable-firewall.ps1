#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Disabling Windows Firewall..." -ForegroundColor Cyan
Write-Host ""
Write-Host "WARNING: This disables network protection!" -ForegroundColor Red
Write-Host "WARNING: System will be exposed to network attacks!" -ForegroundColor Red

$confirm = Read-Host "Type YES to confirm"
if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

$firewallBase = "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy"

$profiles = @{
    "DomainProfile" = "Domain"
    "StandardProfile" = "Private"
    "PublicProfile" = "Public"
}

$count = 1
foreach ($profile in $profiles.Keys) {
    $profileName = $profiles[$profile]
    $profilePath = "$firewallBase\$profile"
    
    Write-Host "[$count/3] Disabling $profileName profile..." -ForegroundColor Yellow
    
    if (Test-Path $profilePath) {
        Set-ItemProperty -Path $profilePath -Name "EnableFirewall" -Value 0 -Type DWord -Force
    }
    $count++
}

# Also set via netsh for immediate effect
Write-Host ""
Write-Host "Applying via netsh..." -ForegroundColor Yellow
netsh advfirewall set allprofiles state off 2>$null

Write-Host ""
Write-Host "Windows Firewall disabled for all profiles." -ForegroundColor Red
