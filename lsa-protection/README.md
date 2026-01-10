# LSA Protection (Protected Process Light)

Controls Local Security Authority (LSA) protection via registry.

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

## Scripts

| Script                       | Description                 |
| ---------------------------- | --------------------------- |
| `enable-lsa-protection.ps1`  | Enables LSA PPL protection  |
| `disable-lsa-protection.ps1` | Disables LSA PPL protection |

## References

- [LSA Protection](https://learn.microsoft.com/en-us/windows-server/security/credentials-protection-and-management/configuring-additional-lsa-protection)
