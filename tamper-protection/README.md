# Tamper Protection

Controls Windows Defender Tamper Protection via registry.

## Quick Usage (Run as Admin)

```powershell
# Enable tamper protection
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/tamper-protection/enable-tamper-protection.ps1 | iex

# Disable tamper protection
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/tamper-protection/disable-tamper-protection.ps1 | iex
```

## Registry Path

`HKLM\SOFTWARE\Microsoft\Windows Defender\Features`

| Key                | Value                   |
| ------------------ | ----------------------- |
| `TamperProtection` | 0/4=Disabled, 5=Enabled |

## Important

- Tamper Protection blocks registry changes to Defender settings when active
- Must often be disabled via Windows Security UI first
- Enterprise management available via Microsoft Defender for Endpoint

## References

- [Tamper Protection](https://learn.microsoft.com/en-us/defender-endpoint/prevent-changes-to-security-settings-with-tamper-protection)
