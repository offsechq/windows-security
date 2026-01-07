# Windows Security Automation

## Overview

PowerShell scripts for configuring and auditing Windows security features. Implements Microsoft-documented methods for managing security components in enterprise environments.

## Usage

- All scripts require Administrator privileges
- Execute scripts directly or review individual headers for parameters
- System restart typically required for changes to take effect
- **Test in non-production environments first**

## References

All scripts follow official Microsoft documentation:

*   [Virtualization-based Security (VBS)](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-vbs)
*   [Credential Guard Overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/)
*   [Memory Integrity and HVCI](https://learn.microsoft.com/en-us/windows-hardware/drivers/install/enabling-memory-integrity)
*   [System Guard Secure Launch and SMM Protection](https://learn.microsoft.com/en-us/windows/security/hardware-security/system-guard-secure-launch-and-smm-protection)
*   [Kernel DMA Protection](https://learn.microsoft.com/en-us/windows/security/hardware-security/kernel-dma-protection-for-thunderbolt)
*   [Microsoft Vulnerable Driver Blocklist](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/design/microsoft-recommended-driver-block-rules)

## Disclaimer

These scripts modify critical system security settings. Test thoroughly before deployment.
