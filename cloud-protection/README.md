# Cloud-Delivered Protection

Controls Windows Defender cloud protection and PUA blocking via registry.

## Quick Usage (Run as Admin)

```powershell
# Enable cloud protection + PUA blocking
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/cloud-protection/enable-cloud-protection.ps1 | iex

# Disable cloud protection
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/cloud-protection/disable-cloud-protection.ps1 | iex
```

## Registry Path

`HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet`

| Key                    | Values                                |
| ---------------------- | ------------------------------------- |
| `SpynetReporting`      | 0=Off, 1=Basic, 2=Advanced            |
| `SubmitSamplesConsent` | 0=Prompt, 1=Safe only, 2=Never, 3=All |

## Features

- Cloud-delivered protection (MAPS)
- Block at First Sight
- PUA (Potentially Unwanted Application) blocking
- Sample submission settings

## References

- [Cloud Protection](https://learn.microsoft.com/en-us/defender-endpoint/cloud-protection-microsoft-defender-antivirus)
- [PUA Protection](https://learn.microsoft.com/en-us/defender-endpoint/detect-block-potentially-unwanted-apps-microsoft-defender-antivirus)
