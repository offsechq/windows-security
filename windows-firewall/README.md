# Windows Firewall

Controls Windows Firewall profiles (Domain, Private, Public) via registry.

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

## Scripts

| Script                 | Description                        |
| ---------------------- | ---------------------------------- |
| `enable-firewall.ps1`  | Enables firewall for all profiles  |
| `disable-firewall.ps1` | Disables firewall for all profiles |

## References

- [Windows Firewall](https://learn.microsoft.com/en-us/windows/security/operating-system-security/network-security/windows-firewall/)
