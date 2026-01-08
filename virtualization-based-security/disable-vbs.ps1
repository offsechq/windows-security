#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Disabling VBS Security Features..." -ForegroundColor Cyan
Write-Host ""
Write-Host "WARNING: This disables important security features!" -ForegroundColor Red

$confirm = Read-Host "Type YES to confirm"
if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

# VBS Core
Write-Host "[1/9] VBS..." -ForegroundColor Yellow
if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard") {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "RequirePlatformSecurityFeatures" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "RequireMicrosoftSignedBootChain" -Value 0 -Type DWord -Force
}

# Credential Guard
Write-Host "[2/9] Credential Guard..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LsaCfgFlags" -Value 0 -Type DWord -Force

# HVCI
Write-Host "[3/9] HVCI..." -ForegroundColor Yellow
$hvciPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
if (Test-Path $hvciPath) {
    Set-ItemProperty -Path $hvciPath -Name "Enabled" -Value 0 -Type DWord -Force
    Remove-ItemProperty -Path $hvciPath -Name "WasEnabledBy" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $hvciPath -Name "AuditModeEnabled" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $hvciPath -Name "Locked" -ErrorAction SilentlyContinue
}

# System Guard
Write-Host "[4/9] System Guard..." -ForegroundColor Yellow
$sgPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\SystemGuard"
if (Test-Path $sgPath) { Set-ItemProperty -Path $sgPath -Name "Enabled" -Value 0 -Type DWord -Force }

# Kernel Shadow Stacks
Write-Host "[5/9] Kernel Shadow Stacks..." -ForegroundColor Yellow
$khspPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks"
if (Test-Path $khspPath) { Set-ItemProperty -Path $khspPath -Name "Enabled" -Value 0 -Type DWord -Force }

# Device Guard Policy
Write-Host "[6/9] Device Guard Policy..." -ForegroundColor Yellow
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
if (Test-Path $policyPath) {
    Set-ItemProperty -Path $policyPath -Name "EnableVirtualizationBasedSecurity" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $policyPath -Name "RequirePlatformSecurityFeatures" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $policyPath -Name "HVCIMATRequired" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $policyPath -Name "LsaCfgFlags" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
}

# Kernel DMA Protection
Write-Host "[7/9] Kernel DMA Protection..." -ForegroundColor Yellow
$dmaPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Kernel DMA Protection"
if (Test-Path $dmaPath) { Remove-Item -Path $dmaPath -Recurse -Force -ErrorAction SilentlyContinue }

# Vulnerable Driver Blocklist
Write-Host "[8/9] Vulnerable Driver Blocklist..." -ForegroundColor Yellow
$vulnDriverPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Config"
if (Test-Path $vulnDriverPath) {
    Set-ItemProperty -Path $vulnDriverPath -Name "VulnerableDriverBlocklistEnable" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
}

# Code Integrity
Write-Host "[9/9] Code Integrity..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "HypervisorEnforcedCodeIntegrity" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
$ciPolicyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy"
if (Test-Path $ciPolicyPath) {
    Set-ItemProperty -Path $ciPolicyPath -Name "VerifiedAndReputablePolicyState" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
}

# Summary
Write-Host ""
Write-Host "All VBS features disabled." -ForegroundColor Red
Write-Host ""
Write-Host "NOTE: UEFI-locked Credential Guard may need additional steps." -ForegroundColor Magenta
Write-Host "  See: https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/configure" -ForegroundColor Gray
Write-Host ""
Write-Host "RESTART REQUIRED" -ForegroundColor Yellow

$restart = Read-Host "Restart now? (Y/N)"
if ($restart -eq "Y" -or $restart -eq "y") {
    Write-Host "Restarting in 5 seconds..." -ForegroundColor Red
    Start-Sleep -Seconds 5
    Restart-Computer -Force
}
