#Requires -RunAsAdministrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator" -ForegroundColor Red
    exit 1
}

Write-Host "Enabling Attack Surface Reduction Rules..." -ForegroundColor Cyan
Write-Host ""

# ASR Rule GUIDs and descriptions
$asrRules = @{
    "56a863a9-875e-4185-98a7-b882c64b5ce5" = "Block abuse of exploited vulnerable signed drivers"
    "7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c" = "Block Adobe Reader from creating child processes"
    "d4f940ab-401b-4efc-aadc-ad5f3c50688a" = "Block all Office applications from creating child processes"
    "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2" = "Block credential stealing from Windows LSASS"
    "be9ba2d9-53ea-4cdc-84e5-9b1eeee46550" = "Block executable content from email client and webmail"
    "01443614-cd74-433a-b99e-2ecdc07bfc25" = "Block executable files from running unless they meet criteria"
    "5beb7efe-fd9a-4556-801d-275e5ffc04cc" = "Block execution of potentially obfuscated scripts"
    "d3e037e1-3eb8-44c8-a917-57927947596d" = "Block JavaScript or VBScript from launching downloaded executable content"
    "3b576869-a4ec-4529-8536-b80a7769e899" = "Block Office applications from creating executable content"
    "75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84" = "Block Office applications from injecting code into other processes"
    "26190899-1602-49e8-8b27-eb1d0a1ce869" = "Block Office communication apps from creating child processes"
    "e6db77e5-3df2-4cf1-b95a-636979351e5b" = "Block persistence through WMI event subscription"
    "d1e49aac-8f56-4280-b9ba-993a6d77406c" = "Block process creations originating from PSExec and WMI commands"
    "33ddedf1-c6e0-47cb-833e-de6133960387" = "Block rebooting machine in Safe Mode"
    "b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4" = "Block untrusted and unsigned processes that run from USB"
    "c0033c00-d16d-4114-a5a0-dc9b3a7d2ceb" = "Block use of copied or impersonated system tools"
    "a8f5898e-1dc8-49a9-9878-85004b8a61e6" = "Block Webshell creation for Servers"
    "92e97fa1-2edf-4476-bdd6-9dd0b4dddc7b" = "Block Win32 API calls from Office macros"
    "c1db55ab-c21a-4637-bb3f-a12568109d35" = "Use advanced protection against ransomware"
}

# Create ASR policy path
$asrPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR"
$rulesPath = "$asrPath\Rules"

if (-not (Test-Path $asrPath)) {
    New-Item -Path $asrPath -Force | Out-Null
}
if (-not (Test-Path $rulesPath)) {
    New-Item -Path $rulesPath -Force | Out-Null
}

# Enable ASR feature
Set-ItemProperty -Path $asrPath -Name "ExploitGuard_ASR_Rules" -Value 1 -Type DWord -Force

Write-Host "Enabling individual ASR rules in Block mode..." -ForegroundColor Yellow
Write-Host ""

$count = 1
$total = $asrRules.Count

foreach ($guid in $asrRules.Keys) {
    $description = $asrRules[$guid]
    Write-Host "[$count/$total] $description" -ForegroundColor Gray
    Set-ItemProperty -Path $rulesPath -Name $guid -Value 1 -Type DWord -Force
    $count++
}

Write-Host ""
Write-Host "All ASR rules enabled in Block mode." -ForegroundColor Green
Write-Host ""
Write-Host "NOTE: Some rules may require Windows Defender to be the primary AV." -ForegroundColor Magenta
Write-Host ""
Write-Host "RESTART RECOMMENDED" -ForegroundColor Yellow
