# Virtualization-Based Security (VBS)

Controls VBS, HVCI, Credential Guard, and related features via registry.

## Quick Usage (Run as Admin)

```powershell
# Enable VBS features
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/virtualization-based-security/enable-vbs.ps1 | iex

# Disable VBS features
irm https://raw.githubusercontent.com/OFFSECHQ/windows-security/main/virtualization-based-security/disable-vbs.ps1 | iex
```

## Features Controlled

- Virtualization-Based Security (VBS)
- Hypervisor-protected Code Integrity (HVCI)
- Credential Guard
- System Guard
- Kernel Shadow Stacks
- Kernel DMA Protection
- Vulnerable Driver Blocklist

## References

- [VBS Overview](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-vbs)
- [Credential Guard](https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/)
- [Memory Integrity](https://learn.microsoft.com/en-us/windows-hardware/drivers/install/enabling-memory-integrity)
