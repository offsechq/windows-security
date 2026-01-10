# Tamper Protection

Controls Windows Defender Tamper Protection via registry.

## Registry Path

`HKLM\SOFTWARE\Microsoft\Windows Defender\Features`

| Key                | Value                   |
| ------------------ | ----------------------- |
| `TamperProtection` | 0/4=Disabled, 5=Enabled |

## Important Notes

- Tamper Protection protects Defender settings from unauthorized changes
- When enabled, registry changes to Defender settings may be blocked
- Must be disabled via Windows Security UI before registry changes work
- Enterprise management via Microsoft Defender for Endpoint

## Scripts

| Script                          | Description                           |
| ------------------------------- | ------------------------------------- |
| `enable-tamper-protection.ps1`  | Enables tamper protection             |
| `disable-tamper-protection.ps1` | Attempts to disable tamper protection |

## References

- [Tamper Protection](https://learn.microsoft.com/en-us/defender-endpoint/prevent-changes-to-security-settings-with-tamper-protection)
