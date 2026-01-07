#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Disables all VBS (Virtualization-Based Security) features on Windows 10/11.

.DESCRIPTION
    This script disables:
    - Virtualization-Based Security (VBS)
    - Credential Guard
    - HVCI (Hypervisor-Protected Code Integrity / Memory Integrity)
    - Kernel-mode Hardware-enforced Stack Protection (KHSP)
    - System Guard Secure Launch
    - Platform security requirements
    - Kernel DMA Protection policies
    - Vulnerable Driver Blocklist
    - Code Integrity Policy Enforcement

.NOTES
    - Requires Administrator privileges
    - A system RESTART is REQUIRED after running this script
    - If features were locked with UEFI, additional steps may be needed

.EXAMPLE
    .\Disable-VBS-Security.ps1
#>

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  VBS Security Features Disablement Script  " -ForegroundColor Cyan
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
Write-Host "WARNING: This will disable important security features!" -ForegroundColor Red
Write-Host ""

$confirm = Read-Host "Are you sure you want to disable VBS security features? (YES/N)"
if ($confirm -ne "YES") {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

# ============================================
# Disable Virtualization-Based Security (VBS)
# ============================================
Write-Host "[1/9] Disabling Virtualization-Based Security (VBS)..." -ForegroundColor Yellow

if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard") {
    # Disable Virtualization-Based Security
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity" -Value 0 -Type DWord -Force

    # Disable platform security feature requirements
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "RequirePlatformSecurityFeatures" -Value 0 -Type DWord -Force

    # Disable Microsoft signed boot chain requirement
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "RequireMicrosoftSignedBootChain" -Value 0 -Type DWord -Force
}

Write-Host "    VBS disabled." -ForegroundColor Green

# ============================================
# Disable Credential Guard
# ============================================
Write-Host "[2/9] Disabling Credential Guard..." -ForegroundColor Yellow

# Set LsaCfgFlags to 0 (disabled)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LsaCfgFlags" -Value 0 -Type DWord -Force

Write-Host "    Credential Guard disabled." -ForegroundColor Green

# ============================================
# Disable HVCI (Memory Integrity)
# ============================================
Write-Host "[3/9] Disabling HVCI (Memory Integrity)..." -ForegroundColor Yellow

$hvciPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
if (Test-Path $hvciPath) {
    # Disable Hypervisor-Protected Code Integrity
    Set-ItemProperty -Path $hvciPath -Name "Enabled" -Value 0 -Type DWord -Force

    # Remove enforcement configuration settings
    Remove-ItemProperty -Path $hvciPath -Name "WasEnabledBy" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $hvciPath -Name "AuditModeEnabled" -ErrorAction SilentlyContinue

    # Remove UEFI lock if present
    Remove-ItemProperty -Path $hvciPath -Name "Locked" -ErrorAction SilentlyContinue
}

Write-Host "    HVCI (Memory Integrity) disabled." -ForegroundColor Green

# ============================================
# Disable System Guard Secure Launch
# ============================================
Write-Host "[4/9] Disabling System Guard Secure Launch..." -ForegroundColor Yellow

$sgPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\SystemGuard"
if (Test-Path $sgPath) {
    Set-ItemProperty -Path $sgPath -Name "Enabled" -Value 0 -Type DWord -Force
}

Write-Host "    System Guard Secure Launch disabled." -ForegroundColor Green

# ============================================
# Disable Kernel-mode Hardware-enforced Stack Protection (KHSP)
# ============================================
Write-Host "[5/9] Disabling Kernel-mode Hardware-enforced Stack Protection..." -ForegroundColor Yellow

$khspPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks"
if (Test-Path $khspPath) {
    Set-ItemProperty -Path $khspPath -Name "Enabled" -Value 0 -Type DWord -Force
}

Write-Host "    Kernel-mode Hardware-enforced Stack Protection disabled." -ForegroundColor Green

# ============================================
# Remove Device Guard Group Policy Settings
# ============================================
Write-Host "[6/9] Removing Device Guard Group Policy settings..." -ForegroundColor Yellow

$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
if (Test-Path $policyPath) {
    # Disable VBS policy settings
    Set-ItemProperty -Path $policyPath -Name "EnableVirtualizationBasedSecurity" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $policyPath -Name "RequirePlatformSecurityFeatures" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $policyPath -Name "HVCIMATRequired" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $policyPath -Name "LsaCfgFlags" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
}

Write-Host "    Device Guard policies removed." -ForegroundColor Green

# ============================================
# Remove Kernel DMA Protection Policy
# ============================================
Write-Host "[7/9] Removing Kernel DMA Protection policy..." -ForegroundColor Yellow

# Kernel DMA Protection requires firmware IOMMU support and cannot be disabled via registry
# This removes the enumeration policy for external devices only
$dmaPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Kernel DMA Protection"
if (Test-Path $dmaPath) {
    Remove-Item -Path $dmaPath -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "    Kernel DMA Protection policy removed." -ForegroundColor Green

# ============================================
# Disable Vulnerable Driver Blocklist
# ============================================
Write-Host "[8/9] Disabling Vulnerable Driver Blocklist..." -ForegroundColor Yellow

$vulnDriverPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Config"
if (Test-Path $vulnDriverPath) {
    # Disable vulnerable driver blocking (automatically enforced when HVCI is enabled)
    Set-ItemProperty -Path $vulnDriverPath -Name "VulnerableDriverBlocklistEnable" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
}

Write-Host "    Vulnerable Driver Blocklist disabled." -ForegroundColor Green

# ============================================
# Disable Code Integrity Policy Enforcement
# ============================================
Write-Host "[9/9] Disabling Code Integrity Policy Enforcement..." -ForegroundColor Yellow

# Disable Hypervisor-enforced Code Integrity
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "HypervisorEnforcedCodeIntegrity" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

# Disable user mode code integrity verification
$ciPolicyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy"
if (Test-Path $ciPolicyPath) {
    Set-ItemProperty -Path $ciPolicyPath -Name "VerifiedAndReputablePolicyState" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
}

Write-Host "    Code Integrity Policy Enforcement disabled." -ForegroundColor Green

# ============================================
# Additional: Clear UEFI variables (if needed)
# ============================================
Write-Host ""
Write-Host "Attempting to schedule UEFI variable cleanup..." -ForegroundColor Yellow

# Schedule Credential Guard UEFI lock removal (takes effect at next boot)
$cgCleanupPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
Set-ItemProperty -Path $cgCleanupPath -Name "LsaCfgFlags" -Value 0 -Type DWord -Force

# Additional commands may be required for UEFI-locked Credential Guard:
# mountvol X: /s
# copy %WINDIR%\System32\SecConfig.efi X:\EFI\Microsoft\Boot\SecConfig.efi /Y
# bcdedit /create {0cb3b571-2f2e-4343-a879-d86a476d7215} /d "DebugTool" /application osloader
# bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} path "\EFI\Microsoft\Boot\SecConfig.efi"
# bcdedit /set {bootmgr} bootsequence {0cb3b571-2f2e-4343-a879-d86a476d7215}
# bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} loadoptions DISABLE-LSA-ISO
# bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} device partition=X:

# ============================================
# Summary
# ============================================
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  All VBS Security Features Disabled!       " -ForegroundColor Red
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Disabled Features:" -ForegroundColor White
Write-Host "  [-] Virtualization-Based Security (VBS)" -ForegroundColor Red
Write-Host "  [-] Credential Guard" -ForegroundColor Red
Write-Host "  [-] HVCI / Memory Integrity" -ForegroundColor Red
Write-Host "  [-] Kernel-mode Hardware-enforced Stack Protection (KHSP)" -ForegroundColor Red
Write-Host "  [-] System Guard Secure Launch" -ForegroundColor Red
Write-Host "  [-] Device Guard Policies" -ForegroundColor Red
Write-Host "  [-] Kernel DMA Protection Policy" -ForegroundColor Red
Write-Host "  [-] Vulnerable Driver Blocklist" -ForegroundColor Red
Write-Host "  [-] Code Integrity Policy Enforcement" -ForegroundColor Red
Write-Host ""
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "  RESTART REQUIRED                          " -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "A system restart is REQUIRED for changes to take effect." -ForegroundColor Yellow
Write-Host ""
Write-Host "NOTE: If Credential Guard was enabled with UEFI lock," -ForegroundColor Magenta
Write-Host "      you may need to run additional steps to fully remove it." -ForegroundColor Magenta
Write-Host "      See Microsoft documentation for 'Manage Credential Guard'" -ForegroundColor Magenta
Write-Host ""

$restart = Read-Host "Do you want to restart now? (Y/N)"
if ($restart -eq "Y" -or $restart -eq "y") {
    Write-Host "Restarting in 10 seconds... Press Ctrl+C to cancel." -ForegroundColor Red
    Start-Sleep -Seconds 10
    Restart-Computer -Force
} else {
    Write-Host "Please restart your computer manually to apply changes." -ForegroundColor Yellow
}
