# Attack Surface Reduction (ASR)

Controls Windows Defender Exploit Guard ASR rules via registry.

## Quick Usage (Run as Admin)

```powershell
# Enable all ASR rules
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/attack-surface-reduction/enable-asr.ps1 | iex

# Disable ASR rules
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/attack-surface-reduction/disable-asr.ps1 | iex
```

## Registry Paths

- **Main Switch**: `HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR`
- **Individual Rules**: Configured by GUID with values 0=Disabled, 1=Block, 2=Audit, 6=Warn

## References

- [ASR Rules Reference](https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-reference)
- [ASR Rules Deployment](https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-deployment)
