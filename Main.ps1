#Install-Module -Name NtObjectManager -RequiredVersion 1.1.32
$DnscacheA = "Powershell Set-Service -Name DnsCache -StartupType Auto"
$DnscacheD = "Powershell Set-Service -Name DnsCache -StartupType Disabled"
import-module ntobjectmanager
if ((Get-Service TrustedInstaller).Status -eq 'Stopped') {
    Start-Service -Name TrustedInstaller
}
Set-NtTokenPrivilege SeDebugPrivilege
$ParentProcess = Get-NtProcess -ServiceName TrustedInstaller
New-Win32Process $DnscacheA -CreationFlags NoWindow -ParentProcess $ParentProcess
Start-Sleep -Seconds 20
if ((Get-Service DnsCache).Status -eq 'Running') {
    Write-Host "DnsCache Running`n"
    Start-Process -FilePath "wsl"
    Start-Process -FilePath "wsaclient" -ArgumentList "/launch wsa://com.android.settings" -NoNewWindow
    New-Win32Process $DnscacheD -CreationFlags NoWindow -ParentProcess $ParentProcess
    Start-Sleep -Seconds 5
    $processId = (Get-WmiObject -Class Win32_Service | Where-Object -Property Name -Like *dnscache*).ProcessId
    Write-Host "$processId`n"
    $Svchost = "Powershell Stop-Process -Id $processId -Force"
    New-Win32Process $Svchost -CreationFlags NoWindow -ParentProcess $ParentProcess
    Start-Sleep -Seconds 3
    if ((Get-Service DnsCache).Status -eq 'Stopped') {
        Write-Host "Success"
    }
}
