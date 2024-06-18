$chocoLibDir = "C:\ProgramData\chocolatey\lib"
$chocoCacheDir = "C:\ProgramData\chocolatey\cache"
$tempDir = [System.IO.Path]::GetTempPath()

#function to delete files and folders
function Clear-Directory($path) {
    if (Test-Path $path) {
        Write-Host "Clearing directory: $path"
        Remove-Item "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "Directory not found: $path"
    }
}

#clear directories
Clear-Directory $chocoLibDir
Clear-Directory $chocoCacheDir
Clear-Directory $tempDir
Write-Host "Temporary files and caches have been cleared."
