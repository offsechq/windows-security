# Windows Security Hardening & Auditing

## Overview

PowerShell scripts for configuring and auditing Windows security features. Implements Microsoft-documented methods for managing security components in enterprise environments.

## Modules

| Module                                                           | Description                               |
| ---------------------------------------------------------------- | ----------------------------------------- |
| [attack-surface-reduction](./attack-surface-reduction)           | ASR rules to block exploit techniques     |
| [cloud-protection](./cloud-protection)                           | Cloud-delivered protection & PUA blocking |
| [exploit-protection](./exploit-protection)                       | Process mitigation settings               |
| [lsa-protection](./lsa-protection)                               | LSA Protected Process Light (PPL)         |
| [network-protection](./network-protection)                       | Block malicious network connections       |
| [realtime-protection](./realtime-protection)                     | Defender real-time monitoring             |
| [smartscreen](./smartscreen)                                     | App & file reputation checks              |
| [tamper-protection](./tamper-protection)                         | Protect Defender settings                 |
| [virtualization-based-security](./virtualization-based-security) | VBS, HVCI, Credential Guard               |
| [windows-firewall](./windows-firewall)                           | Firewall profile management               |

## Usage

- All scripts require Administrator privileges
- Execute scripts directly or review individual headers for parameters
- System restart typically required for changes to take effect
- **Test in non-production environments first**

## References

- [Virtualization-based Security (VBS)](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-vbs)
- [Attack Surface Reduction Rules](https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-reference)
- [Network Protection](https://learn.microsoft.com/en-us/defender-endpoint/network-protection)
- [SmartScreen Overview](https://learn.microsoft.com/en-us/windows/security/operating-system-security/virus-and-threat-protection/microsoft-defender-smartscreen/)
- [LSA Protection](https://learn.microsoft.com/en-us/windows-server/security/credentials-protection-and-management/configuring-additional-lsa-protection)
- [Tamper Protection](https://learn.microsoft.com/en-us/defender-endpoint/prevent-changes-to-security-settings-with-tamper-protection)

## Disclaimer

These scripts modify critical system security settings. Test thoroughly before deployment.
