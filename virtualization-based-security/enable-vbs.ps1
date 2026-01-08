#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Enabling VBS Security Features..." -ForegroundColor Cyan
Write-Host ""

# VBS Core
Write-Host "[1/9] VBS..." -ForegroundColor Yellow
if (-not (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard")) {
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "RequirePlatformSecurityFeatures" -Value 3 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "RequireMicrosoftSignedBootChain" -Value 1 -Type DWord -Force

# Credential Guard
Write-Host "[2/9] Credential Guard..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LsaCfgFlags" -Value 1 -Type DWord -Force

# HVCI
Write-Host "[3/9] HVCI (Memory Integrity)..." -ForegroundColor Yellow
$hvciPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
if (-not (Test-Path $hvciPath)) { New-Item -Path $hvciPath -Force | Out-Null }
Set-ItemProperty -Path $hvciPath -Name "Enabled" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $hvciPath -Name "WasEnabledBy" -Value 2 -Type DWord -Force
Set-ItemProperty -Path $hvciPath -Name "AuditModeEnabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $hvciPath -Name "Locked" -Value 1 -Type DWord -Force

# System Guard
Write-Host "[4/9] System Guard..." -ForegroundColor Yellow
$sgPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\SystemGuard"
if (-not (Test-Path $sgPath)) { New-Item -Path $sgPath -Force | Out-Null }
Set-ItemProperty -Path $sgPath -Name "Enabled" -Value 1 -Type DWord -Force

# Kernel Shadow Stacks (Win11 22H2+)
Write-Host "[5/9] Kernel Shadow Stacks..." -ForegroundColor Yellow
$khspPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks"
if (-not (Test-Path $khspPath)) { New-Item -Path $khspPath -Force | Out-Null }
Set-ItemProperty -Path $khspPath -Name "Enabled" -Value 1 -Type DWord -Force

# Device Guard Policy
Write-Host "[6/9] Device Guard Policy..." -ForegroundColor Yellow
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
if (-not (Test-Path $policyPath)) { New-Item -Path $policyPath -Force | Out-Null }
Set-ItemProperty -Path $policyPath -Name "EnableVirtualizationBasedSecurity" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $policyPath -Name "RequirePlatformSecurityFeatures" -Value 3 -Type DWord -Force
Set-ItemProperty -Path $policyPath -Name "HVCIMATRequired" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $policyPath -Name "LsaCfgFlags" -Value 1 -Type DWord -Force

# Kernel DMA Protection
Write-Host "[7/9] Kernel DMA Protection..." -ForegroundColor Yellow
$dmaPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Kernel DMA Protection"
if (-not (Test-Path $dmaPath)) { New-Item -Path $dmaPath -Force | Out-Null }
Set-ItemProperty -Path $dmaPath -Name "DeviceEnumerationPolicy" -Value 0 -Type DWord -Force

# Vulnerable Driver Blocklist
Write-Host "[8/9] Vulnerable Driver Blocklist..." -ForegroundColor Yellow
$vulnDriverPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Config"
if (-not (Test-Path $vulnDriverPath)) { New-Item -Path $vulnDriverPath -Force | Out-Null }
Set-ItemProperty -Path $vulnDriverPath -Name "VulnerableDriverBlocklistEnable" -Value 1 -Type DWord -Force

# Code Integrity
Write-Host "[9/9] Code Integrity..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "HypervisorEnforcedCodeIntegrity" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
$ciPolicyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy"
if (-not (Test-Path $ciPolicyPath)) { New-Item -Path $ciPolicyPath -Force | Out-Null }
Set-ItemProperty -Path $ciPolicyPath -Name "VerifiedAndReputablePolicyState" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

# Summary
Write-Host ""
Write-Host "All VBS features enabled." -ForegroundColor Green
Write-Host ""
Write-Host "Verify after restart:" -ForegroundColor Yellow
Write-Host "  Get-ComputerInfo | Select-Object DeviceGuard*" -ForegroundColor Gray
Write-Host ""
Write-Host "RESTART REQUIRED" -ForegroundColor Yellow

$restart = Read-Host "Restart now? (Y/N)"
if ($restart -eq "Y" -or $restart -eq "y") {
    Write-Host "Restarting in 5 seconds..." -ForegroundColor Red
    Start-Sleep -Seconds 5
    Restart-Computer -Force
}
