# SmartScreen

Controls Windows Defender SmartScreen via registry.

## Registry Paths

| Path                                                      | Key                     | Values                      |
| --------------------------------------------------------- | ----------------------- | --------------------------- |
| `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer` | `SmartScreenEnabled`    | Off/Warn/Block/RequireAdmin |
| `HKLM\SOFTWARE\Policies\Microsoft\Windows\System`         | `EnableSmartScreen`     | 0=Off, 1=On                 |
| `HKLM\SOFTWARE\Policies\Microsoft\Windows\System`         | `ShellSmartScreenLevel` | Warn/Block                  |

## Scripts

| Script                    | Description                         |
| ------------------------- | ----------------------------------- |
| `enable-smartscreen.ps1`  | Enables SmartScreen with Block mode |
| `disable-smartscreen.ps1` | Disables SmartScreen                |

## References

- [SmartScreen Overview](https://learn.microsoft.com/en-us/windows/security/operating-system-security/virus-and-threat-protection/microsoft-defender-smartscreen/)
