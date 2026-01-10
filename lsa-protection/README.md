# LSA Protection (Protected Process Light)

Controls Local Security Authority (LSA) protection via registry.

## Quick Usage (Run as Admin)

```powershell
# Enable LSA protection
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/lsa-protection/enable-lsa-protection.ps1 | iex

# Disable LSA protection
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/lsa-protection/disable-lsa-protection.ps1 | iex
```

## Registry Path

`HKLM\SYSTEM\CurrentControlSet\Control\Lsa`

| Key        | Description             |
| ---------- | ----------------------- |
| `RunAsPPL` | 1=Enable PPL, 0=Disable |

## About

LSA Protection runs lsass.exe as a Protected Process Light (PPL), preventing:

- Credential theft attacks (Mimikatz, etc.)
- Code injection into LSASS
- Memory dumping of credentials

**Restart required after changes.**

## References

- [LSA Protection](https://learn.microsoft.com/en-us/windows-server/security/credentials-protection-and-management/configuring-additional-lsa-protection)
