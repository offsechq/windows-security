# SmartScreen

Controls Windows Defender SmartScreen via registry.

## Quick Usage (Run as Admin)

```powershell
# Enable SmartScreen
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/smartscreen/enable-smartscreen.ps1 | iex

# Disable SmartScreen
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/smartscreen/disable-smartscreen.ps1 | iex
```

## Registry Paths

| Path                                                      | Key                  | Values         |
| --------------------------------------------------------- | -------------------- | -------------- |
| `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer` | `SmartScreenEnabled` | Off/Warn/Block |
| `HKLM\SOFTWARE\Policies\Microsoft\Windows\System`         | `EnableSmartScreen`  | 0=Off, 1=On    |

## References

- [SmartScreen Overview](https://learn.microsoft.com/en-us/windows/security/operating-system-security/virus-and-threat-protection/microsoft-defender-smartscreen/)
