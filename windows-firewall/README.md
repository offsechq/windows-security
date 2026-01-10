# Windows Firewall

Controls Windows Firewall profiles (Domain, Private, Public) via registry.

## Quick Usage (Run as Admin)

```powershell
# Enable firewall (all profiles)
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/windows-firewall/enable-firewall.ps1 | iex

# Disable firewall (all profiles)
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/windows-firewall/disable-firewall.ps1 | iex
```

## Registry Path

`HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy`

| Profile | Subkey            |
| ------- | ----------------- |
| Domain  | `DomainProfile`   |
| Private | `StandardProfile` |
| Public  | `PublicProfile`   |

| Key              | Values      |
| ---------------- | ----------- |
| `EnableFirewall` | 0=Off, 1=On |

## References

- [Windows Firewall](https://learn.microsoft.com/en-us/windows/security/operating-system-security/network-security/windows-firewall/)
