import-module servermanager
add-windowsfeature web-server -includeallsubfeature
add-windowsfeature Web-Asp-Net45
add-windowsfeature NET-Framework-Features 
Set-Content -Path "C:\inetpub\wwwroot\webpage1.html" -Value "Hello $($env:computername) ! , i feel great"