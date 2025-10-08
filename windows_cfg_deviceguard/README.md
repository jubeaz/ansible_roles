# todo
# manage DMA
## HVCI
https://learn.microsoft.com/en-us/windows/security/hardware-security/enable-virtualization-based-protection-of-code-integrity?tabs=reg

# Notes
## Credential guard
https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/configure?tabs=reg

```powershell
bcdedit | findstr -i hypervisor
bcdedit /set hypervisorlaunchtype auto
reboot
systeminfo | findstr /i "hypervisor"

```
https://download.microsoft.com/download/b/d/8/bd821b1f-05f2-4a7e-aa03-df6c4f687b07/dgreadiness_v3.6.zip
```powershell
 .\DG_Readiness_Tool_v3.6.ps1 -Ready
```

```
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard' -Name EnableVirtualizationBasedSecurity -Value 1 -Type DWord
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard' -Name RequirePlatformSecurityFeatures -Value 1 -Type DWord
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name LsaCfgFlags -Value 1 -Type DWord
```

check (must be 1):
```powershell
(Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard).SecurityServicesRunning
```

Open the Event Viewer (eventvwr.exe) and go to Windows Logs\System and filter the event sources for WinInit:
* event ID 14
