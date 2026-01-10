# Network Protection

Controls Windows Defender Network Protection via registry.

## Registry Path

`HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection`

| Value | Description     |
| ----- | --------------- |
| 0     | Disabled        |
| 1     | Enabled (Block) |
| 2     | Audit Mode      |

## Scripts

| Script                           | Description                 |
| -------------------------------- | --------------------------- |
| `enable-network-protection.ps1`  | Enables network protection  |
| `disable-network-protection.ps1` | Disables network protection |

## References

- [Network Protection Overview](https://learn.microsoft.com/en-us/defender-endpoint/network-protection)
