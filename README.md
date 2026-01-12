# Windows Security Hardening & Auditing

PowerShell scripts for configuring Windows security features via registry. Run directly without downloading.

## Quick Usage (Run as Admin)

```powershell
# Enable Everything (Tamper Protection last)
$b="https://raw.githubusercontent.com/OFFSECHQ/windows-security/main"; "attack-surface-reduction/enable-asr.ps1","cloud-protection/enable-cloud-protection.ps1","exploit-protection/enable-exploit-protection.ps1","lsa-protection/enable-lsa-protection.ps1","network-protection/enable-network-protection.ps1","realtime-protection/enable-realtime-protection.ps1","smartscreen/enable-smartscreen.ps1","virtualization-based-security/enable-vbs.ps1","windows-firewall/enable-firewall.ps1","tamper-protection/enable-tamper-protection.ps1" | %{irm "$b/$_" | iex}

# Disable Everything (Tamper Protection first)
$b="https://raw.githubusercontent.com/OFFSECHQ/windows-security/main"; "tamper-protection/disable-tamper-protection.ps1","attack-surface-reduction/disable-asr.ps1","cloud-protection/disable-cloud-protection.ps1","exploit-protection/disable-exploit-protection.ps1","lsa-protection/disable-lsa-protection.ps1","network-protection/disable-network-protection.ps1","realtime-protection/disable-realtime-protection.ps1","smartscreen/disable-smartscreen.ps1","virtualization-based-security/disable-vbs.ps1","windows-firewall/disable-firewall.ps1" | %{irm "$b/$_" | iex}
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
