# Windows Security Hardening & Auditing

PowerShell scripts for configuring Windows security features via registry. Run directly without downloading.

## Quick Usage (Run as Admin)

```powershell
# Example: Enable ASR rules
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/attack-surface-reduction/enable-asr.ps1 | iex

# Example: Disable VBS
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/virtualization-based-security/disable-vbs.ps1 | iex
```

## Modules

| Module                                                           | Enable                                          | Disable                                          |
| ---------------------------------------------------------------- | ----------------------------------------------- | ------------------------------------------------ |
| [attack-surface-reduction](./attack-surface-reduction)           | `irm .../enable-asr.ps1 \| iex`                 | `irm .../disable-asr.ps1 \| iex`                 |
| [cloud-protection](./cloud-protection)                           | `irm .../enable-cloud-protection.ps1 \| iex`    | `irm .../disable-cloud-protection.ps1 \| iex`    |
| [exploit-protection](./exploit-protection)                       | `irm .../enable-exploit-protection.ps1 \| iex`  | `irm .../disable-exploit-protection.ps1 \| iex`  |
| [lsa-protection](./lsa-protection)                               | `irm .../enable-lsa-protection.ps1 \| iex`      | `irm .../disable-lsa-protection.ps1 \| iex`      |
| [network-protection](./network-protection)                       | `irm .../enable-network-protection.ps1 \| iex`  | `irm .../disable-network-protection.ps1 \| iex`  |
| [realtime-protection](./realtime-protection)                     | `irm .../enable-realtime-protection.ps1 \| iex` | `irm .../disable-realtime-protection.ps1 \| iex` |
| [smartscreen](./smartscreen)                                     | `irm .../enable-smartscreen.ps1 \| iex`         | `irm .../disable-smartscreen.ps1 \| iex`         |
| [tamper-protection](./tamper-protection)                         | `irm .../enable-tamper-protection.ps1 \| iex`   | `irm .../disable-tamper-protection.ps1 \| iex`   |
| [virtualization-based-security](./virtualization-based-security) | `irm .../enable-vbs.ps1 \| iex`                 | `irm .../disable-vbs.ps1 \| iex`                 |
| [windows-firewall](./windows-firewall)                           | `irm .../enable-firewall.ps1 \| iex`            | `irm .../disable-firewall.ps1 \| iex`            |

> **Base URL**: `https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/`

## Notes

- All scripts require Administrator privileges
- Restart typically required for changes to take effect
- **Test in non-production environments first**

## Disclaimer

These scripts modify critical system security settings. Test thoroughly before deployment.
