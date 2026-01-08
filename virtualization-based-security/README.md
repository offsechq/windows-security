# VBS Security Scripts

Manage Windows Virtualization-Based Security features via PowerShell.

## Structure

```
virtualization-based-security/
├── enable-vbs.ps1   # Enable all VBS features
└── disable-vbs.ps1  # Disable all VBS features
```

## Features Managed

- Virtualization-Based Security (VBS)
- Credential Guard (UEFI-locked)
- HVCI / Memory Integrity
- Kernel-mode Hardware-enforced Stack Protection
- System Guard Secure Launch
- Kernel DMA Protection
- Vulnerable Driver Blocklist
- Code Integrity Policy Enforcement

## Usage

Run as **Administrator**:

```powershell
# Enable all VBS features
.\enable-vbs.ps1

# Disable all VBS features (requires "YES" confirmation)
.\disable-vbs.ps1
```

## Requirements

- Windows 10/11
- UEFI with Secure Boot enabled
- CPU virtualization (Intel VT-x / AMD-V) enabled in BIOS
- TPM 2.0 (recommended)

## Notes

- **Restart required** after running either script
- UEFI-locked features may require [additional steps](https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/configure) to fully disable
- Verify with: `Get-ComputerInfo | Select-Object DeviceGuard*`
