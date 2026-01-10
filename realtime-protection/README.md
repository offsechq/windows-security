# Real-time Protection (Defender Antivirus)

Controls Windows Defender real-time protection via registry.

## Quick Usage (Run as Admin)

```powershell
# Enable real-time protection
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/realtime-protection/enable-realtime-protection.ps1 | iex

# Disable real-time protection
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/realtime-protection/disable-realtime-protection.ps1 | iex
```

## Registry Path

`HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection`

| Key                         | Description                    |
| --------------------------- | ------------------------------ |
| `DisableRealtimeMonitoring` | 1=Disable real-time protection |
| `DisableBehaviorMonitoring` | 1=Disable behavior monitoring  |
| `DisableOnAccessProtection` | 1=Disable on-access protection |

## References

- [Real-time Protection](https://learn.microsoft.com/en-us/defender-endpoint/configure-real-time-protection-microsoft-defender-antivirus)
