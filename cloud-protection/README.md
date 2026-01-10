# Cloud-Delivered Protection

Controls Windows Defender cloud protection and sample submission settings via registry.

## Registry Path

`HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet`

| Key                    | Values                                       |
| ---------------------- | -------------------------------------------- |
| `SpynetReporting`      | 0=Off, 1=Basic, 2=Advanced                   |
| `SubmitSamplesConsent` | 0=Always prompt, 1=Safe only, 2=Never, 3=All |

## Also Includes

- PUA (Potentially Unwanted Application) blocking
- Block at First Sight feature

## Scripts

| Script                         | Description                               |
| ------------------------------ | ----------------------------------------- |
| `enable-cloud-protection.ps1`  | Enables cloud protection and PUA blocking |
| `disable-cloud-protection.ps1` | Disables cloud protection                 |

## References

- [Cloud Protection](https://learn.microsoft.com/en-us/defender-endpoint/cloud-protection-microsoft-defender-antivirus)
- [PUA Protection](https://learn.microsoft.com/en-us/defender-endpoint/detect-block-potentially-unwanted-apps-microsoft-defender-antivirus)
