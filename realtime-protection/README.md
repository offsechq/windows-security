# Real-time Protection (Defender Antivirus)

Controls Windows Defender real-time protection and related features via registry.

## Registry Path

`HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection`

| Key                           | Description                    |
| ----------------------------- | ------------------------------ |
| `DisableRealtimeMonitoring`   | 1=Disable real-time protection |
| `DisableBehaviorMonitoring`   | 1=Disable behavior monitoring  |
| `DisableOnAccessProtection`   | 1=Disable on-access protection |
| `DisableScanOnRealtimeEnable` | 1=Disable scan on enable       |

## Scripts

| Script                            | Description                   |
| --------------------------------- | ----------------------------- |
| `enable-realtime-protection.ps1`  | Enables real-time protection  |
| `disable-realtime-protection.ps1` | Disables real-time protection |

## References

- [Real-time Protection](https://learn.microsoft.com/en-us/defender-endpoint/configure-real-time-protection-microsoft-defender-antivirus)
