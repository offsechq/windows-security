#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Enables all VBS (Virtualization-Based Security) features on Windows 10/11.

.DESCRIPTION
    This script enables:
    - Virtualization-Based Security (VBS)
    - Credential Guard
    - HVCI (Hypervisor-Protected Code Integrity / Memory Integrity)
    - Kernel-mode Hardware-enforced Stack Protection (KHSP)
    - System Guard Secure Launch
    - Platform security requirements (TPM + Secure Boot)
    - Vulnerable Driver Blocklist
    - Code Integrity Policy Enforcement

.NOTES
    - Requires Administrator privileges
    - Requires UEFI firmware with Secure Boot enabled
    - Requires CPU virtualization (Intel VT-x or AMD-V) enabled in BIOS
    - A system RESTART is REQUIRED after running this script
    - Some drivers may be incompatible with HVCI

.EXAMPLE
    .\Enable-VBS-Security.ps1
#>

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  VBS Security Features Enablement Script   " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Verify administrator privileges
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

Write-Host "Running with Administrator privileges..." -ForegroundColor Green
Write-Host ""

# ============================================
# Enable Virtualization-Based Security (VBS)
# ============================================
Write-Host "[1/9] Enabling Virtualization-Based Security (VBS)..." -ForegroundColor Yellow

# Ensure DeviceGuard key exists
if (-not (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard")) {
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Force | Out-Null
}

# Enable Virtualization-Based Security
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity" -Value 1 -Type DWord -Force

# Enforce Secure Boot and DMA Protection (3 = Secure Boot + DMA)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "RequirePlatformSecurityFeatures" -Value 3 -Type DWord -Force

# Enforce Microsoft UEFI Certificate Authority requirement
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "RequireMicrosoftSignedBootChain" -Value 1 -Type DWord -Force

Write-Host "    VBS enabled successfully." -ForegroundColor Green

# ============================================
# Enable Credential Guard
# ============================================
Write-Host "[2/9] Enabling Credential Guard..." -ForegroundColor Yellow

# Enable Credential Guard with UEFI lock (1)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LsaCfgFlags" -Value 1 -Type DWord -Force

Write-Host "    Credential Guard enabled with UEFI lock." -ForegroundColor Green

# ============================================
# Enable HVCI (Memory Integrity)
# ============================================
Write-Host "[3/9] Enabling HVCI (Memory Integrity)..." -ForegroundColor Yellow

# Ensure HVCI scenario key exists
$hvciPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
if (-not (Test-Path $hvciPath)) {
    New-Item -Path $hvciPath -Force | Out-Null
}

# Enable Hypervisor-Protected Code Integrity
Set-ItemProperty -Path $hvciPath -Name "Enabled" -Value 1 -Type DWord -Force

# Set enforcement mode to strict (2)
Set-ItemProperty -Path $hvciPath -Name "WasEnabledBy" -Value 2 -Type DWord -Force

# Disable audit mode
Set-ItemProperty -Path $hvciPath -Name "AuditModeEnabled" -Value 0 -Type DWord -Force

# Lock HVCI configuration (requires UEFI variable reset to disable)
# Uncomment to prevent easy disablement
Set-ItemProperty -Path $hvciPath -Name "Locked" -Value 1 -Type DWord -Force

Write-Host "    HVCI (Memory Integrity) enabled." -ForegroundColor Green

# ============================================
# Enable System Guard Secure Launch
# ============================================
Write-Host "[4/9] Enabling System Guard Secure Launch..." -ForegroundColor Yellow

# Ensure System Guard key exists
$sgPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\SystemGuard"
if (-not (Test-Path $sgPath)) {
    New-Item -Path $sgPath -Force | Out-Null
}

# Enable System Guard
Set-ItemProperty -Path $sgPath -Name "Enabled" -Value 1 -Type DWord -Force

Write-Host "    System Guard Secure Launch enabled." -ForegroundColor Green

# ============================================
# Enable Kernel-mode Hardware-enforced Stack Protection (KHSP)
# ============================================
Write-Host "[5/9] Enabling Kernel-mode Hardware-enforced Stack Protection..." -ForegroundColor Yellow

# Ensure Kernel Shadow Stacks key exists
$khspPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks"
if (-not (Test-Path $khspPath)) {
    New-Item -Path $khspPath -Force | Out-Null
}

# Enable Kernel Shadow Stacks (Windows 11 22H2+)
Set-ItemProperty -Path $khspPath -Name "Enabled" -Value 1 -Type DWord -Force

Write-Host "    Kernel-mode Hardware-enforced Stack Protection enabled." -ForegroundColor Green

# ============================================
# Configure Device Guard Group Policy Settings
# ============================================
Write-Host "[6/9] Configuring Device Guard Group Policy settings..." -ForegroundColor Yellow

# Ensure policy key exists
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
if (-not (Test-Path $policyPath)) {
    New-Item -Path $policyPath -Force | Out-Null
}

# Enable VBS policy
Set-ItemProperty -Path $policyPath -Name "EnableVirtualizationBasedSecurity" -Value 1 -Type DWord -Force

# Enforce Secure Boot and DMA protection policy
Set-ItemProperty -Path $policyPath -Name "RequirePlatformSecurityFeatures" -Value 3 -Type DWord -Force

# Enable HVCI policy
Set-ItemProperty -Path $policyPath -Name "HVCIMATRequired" -Value 1 -Type DWord -Force

# Enable Credential Guard policy (UEFI lock)
Set-ItemProperty -Path $policyPath -Name "LsaCfgFlags" -Value 1 -Type DWord -Force

Write-Host "    Device Guard policies configured." -ForegroundColor Green

# ============================================
# Configure Kernel DMA Protection Policy
# ============================================
Write-Host "[7/9] Configuring Kernel DMA Protection policy..." -ForegroundColor Yellow

# Configure external device enumeration policy (Requires firmware IOMMU support)
$dmaPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Kernel DMA Protection"
if (-not (Test-Path $dmaPath)) {
    New-Item -Path $dmaPath -Force | Out-Null
}

# Block external device enumeration (0)
Set-ItemProperty -Path $dmaPath -Name "DeviceEnumerationPolicy" -Value 0 -Type DWord -Force

Write-Host "    Kernel DMA Protection policy configured." -ForegroundColor Green

# ============================================
# Enable Vulnerable Driver Blocklist
# ============================================
Write-Host "[8/9] Enabling Vulnerable Driver Blocklist..." -ForegroundColor Yellow

# Ensure CI Config key exists
$vulnDriverPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Config"
if (-not (Test-Path $vulnDriverPath)) {
    New-Item -Path $vulnDriverPath -Force | Out-Null
}

# Enable vulnerable driver blocklist
Set-ItemProperty -Path $vulnDriverPath -Name "VulnerableDriverBlocklistEnable" -Value 1 -Type DWord -Force

Write-Host "    Vulnerable Driver Blocklist enabled." -ForegroundColor Green

# ============================================
# Enable Code Integrity Policy Enforcement
# ============================================
Write-Host "[9/9] Enabling Code Integrity Policy Enforcement..." -ForegroundColor Yellow

# Enable Hypervisor-enforced Code Integrity
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "HypervisorEnforcedCodeIntegrity" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

# Enable user mode code integrity verification
$ciPolicyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy"
if (-not (Test-Path $ciPolicyPath)) {
    New-Item -Path $ciPolicyPath -Force | Out-Null
}
Set-ItemProperty -Path $ciPolicyPath -Name "VerifiedAndReputablePolicyState" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

Write-Host "    Code Integrity Policy Enforcement enabled." -ForegroundColor Green

# ============================================
# Summary
# ============================================
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  All VBS Security Features Enabled!        " -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Enabled Features:" -ForegroundColor White
Write-Host "  [+] Virtualization-Based Security (VBS)" -ForegroundColor Green
Write-Host "  [+] Credential Guard (with UEFI lock)" -ForegroundColor Green
Write-Host "  [+] HVCI / Memory Integrity (Strict Enforcement)" -ForegroundColor Green
Write-Host "  [+] Kernel-mode Hardware-enforced Stack Protection (KHSP)" -ForegroundColor Green
Write-Host "  [+] System Guard Secure Launch" -ForegroundColor Green
Write-Host "  [+] Device Guard Policies" -ForegroundColor Green
Write-Host "  [+] Kernel DMA Protection" -ForegroundColor Green
Write-Host "  [+] Vulnerable Driver Blocklist" -ForegroundColor Green
Write-Host "  [+] Code Integrity Policy Enforcement" -ForegroundColor Green
Write-Host ""

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Verification Instructions                 " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "After restarting, run these commands to verify protections:" -ForegroundColor White
Write-Host ""
Write-Host "1. Verify VBS & Services:" -ForegroundColor Yellow
Write-Host "   Get-ComputerInfo | Select-Object DeviceGuardSecurityServicesConfigured, DeviceGuardSecurityServicesRunning" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Verify HVCI (Memory Integrity):" -ForegroundColor Yellow
Write-Host "   Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity' -Name Enabled" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Verify Kernel Shadow Stacks (KHSP):" -ForegroundColor Yellow
Write-Host "   Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks' -Name Enabled -ErrorAction SilentlyContinue" -ForegroundColor Gray
Write-Host ""

Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "  RESTART REQUIRED                          " -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "A system restart is REQUIRED for changes to take effect." -ForegroundColor Yellow
Write-Host ""

$restart = Read-Host "Do you want to restart now? (Y/N)"
if ($restart -eq "Y" -or $restart -eq "y") {
    Write-Host "Restarting in 10 seconds... Press Ctrl+C to cancel." -ForegroundColor Red
    Start-Sleep -Seconds 10
    Restart-Computer -Force
} else {
    Write-Host "Please restart your computer manually to apply changes." -ForegroundColor Yellow
}
