# Network Protection

Controls Windows Defender Network Protection via registry.

## Quick Usage (Run as Admin)

```powershell
# Enable network protection
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/network-protection/enable-network-protection.ps1 | iex

# Disable network protection
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/network-protection/disable-network-protection.ps1 | iex
```

## Registry Path

`HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection`

| Value | Description     |
| ----- | --------------- |
| 0     | Disabled        |
| 1     | Enabled (Block) |
| 2     | Audit Mode      |

## References

- [Network Protection Overview](https://learn.microsoft.com/en-us/defender-endpoint/network-protection)
