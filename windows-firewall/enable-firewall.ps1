#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Enabling Windows Firewall..." -ForegroundColor Cyan
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
    
    Write-Host "[$count/3] Enabling $profileName profile..." -ForegroundColor Yellow
    
    if (-not (Test-Path $profilePath)) {
        New-Item -Path $profilePath -Force | Out-Null
    }
    
    Set-ItemProperty -Path $profilePath -Name "EnableFirewall" -Value 1 -Type DWord -Force
    $count++
}

# Also set via netsh for immediate effect
Write-Host ""
Write-Host "Applying via netsh..." -ForegroundColor Yellow
netsh advfirewall set allprofiles state on 2>$null

Write-Host ""
Write-Host "Windows Firewall enabled for all profiles." -ForegroundColor Green
Write-Host ""
Write-Host "Profiles enabled:" -ForegroundColor Cyan
Write-Host "  - Domain" -ForegroundColor Gray
Write-Host "  - Private" -ForegroundColor Gray
Write-Host "  - Public" -ForegroundColor Gray
