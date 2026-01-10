# Attack Surface Reduction (ASR)

Controls Windows Defender Exploit Guard ASR rules via registry.

## Registry Paths

- **Main Switch**: `HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR`
- **Individual Rules**: Configured by GUID with values 0=Disabled, 1=Block, 2=Audit, 6=Warn

## Scripts

| Script            | Description                         |
| ----------------- | ----------------------------------- |
| `enable-asr.ps1`  | Enables all ASR rules in Block mode |
| `disable-asr.ps1` | Disables all ASR rules              |

## References

- [ASR Rules Reference](https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-reference)
- [ASR Rules Deployment](https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-deployment)
