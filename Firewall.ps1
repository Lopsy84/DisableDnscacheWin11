Set-Service -Name dnscache -StartupType Disabled
# Run WSL command
Start-Process -FilePath "wsl"
# Run WSA client command
Start-Process -FilePath "wsaclient" -ArgumentList "/launch wsa://com.android.settings" -NoNewWindow
# Wait for WSA client to start (adjust the sleep duration if needed)
Start-Sleep -Seconds 5
# Find the process ID (PID) associated with the service
$processId = (Get-WmiObject -Class Win32_Service | Where-Object -Property Name -Like *dnscache*).ProcessId
Write-Host $processId
Stop-Process -Id $processId -Force

