# Temporarily bypass execution policy with unsigned script
Set-ExecutionPolicy Bypass -Scope Process -Force

#Chocolatey:
Write-Host "Installing Chocolatey if not installed."
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Installing Chocolatey..."
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
choco upgrade chocolatey -y

#Function to call Chocolatey and install a package if it's not already installed.
#function Install-ChocoPackageIfNotInstalled {
    #param (
        #[string]$packageName
    #)

    #if (-not (choco list --local-only | Select-String $packageName)) {
        #choco install $packageName -y
    #} else {
        #Write-Host "$packageName is already installed."
    #}
#}
function Install-ChocoPackageIfNotInstalled {
    param (
        [string]$packageName,
        [string]$version = $null,     # Optional version argument
        [string]$installArgs = $null  # Optional install arguments
    )

    # Check if the package is installed
    if (-not (choco list --local-only | Select-String $packageName)) {
        $command = "choco install $packageName -y"
        
        if ($version) {
            $command += " --version=$version"
        }
        
        if ($installArgs) {
            $command += " --installargs='$installArgs'"
        }

        Invoke-Expression $command
    } else {
        Write-Host "$packageName is already installed."
    }
}

#WSL-Ubuntu:
Write-Host "Installing Ubuntu Preview WSL if not installed."
if (-not (wsl --list --verbose | Select-String "Ubuntu-Preview")) {
    wsl --install -d Ubuntu-Preview
} else {
    Write-Host "Ubuntu Preview is already installed."
}
#IDE:
Write-Host "Installing IDEs and related software."
Install-ChocoPackageIfNotInstalled "visualstudio2022community"

#JB/IDE:
Install-ChocoPackageIfNotInstalled "jetbrainstoolbox"

#Text Editor:
Write-Host "Installing text editors"
Install-ChocoPackageIfNotInstalled "neovim"
Install-ChocoPackageIfNotInstalled "vscode"

#Coding Tools:
Write-Host "Installing common software development tools."
Install-ChocoPackageIfNotInstalled "docker-desktop"
Install-ChocoPackageIfNotInstalled "github-desktop"
Install-ChocoPackageIfNotInstalled "git"
#Install-ChocoPackageIfNotInstalled "cmake --installargs 'ADD_CMAKE_TO_PATH=System'"
Install-ChocoPackageIfNotInstalled -packageName "cmake" -installArgs "ADD_CMAKE_TO_PATH=System"
Install-ChocoPackageIfNotInstalled "msys2"

#Messaging:
Write-Host "Installing messaging software."
Install-ChocoPackageIfNotInstalled "signal"

#Gaming/Launcher:
Write-Host "Installing game launchers"
Install-ChocoPackageIfNotInstalled "steam"
Install-ChocoPackageIfNotInstalled "epicgameslauncher"
Install-ChocoPackageIfNotInstalled "goggalaxy"

#Emulation/VM:
Write-Host "Installing VM software"
Install-ChocoPackageIfNotInstalled "virtualbox"
#QEMU?

#Conda:
Write-Host "Installing python and tools."
Install-ChocoPackageIfNotInstalled "miniconda3"

#Python3
#Python3-aider: added to LLM
Install-ChocoPackageIfNotInstalled -packageName "python" -version "3.12.0"

#Always run after Python3 setup
#LLM:
Write-Host "Installing LLM software."
Install-ChocoPackageIfNotInstalled "ollama"
python -m pip install -U aider-chat

#Misc:
Write-Host "Installing miscellaneous Windows software."
Install-ChocoPackageIfNotInstalled "okular"
Install-ChocoPackageIfNotInstalled "powertoys"
Install-ChocoPackageIfNotInstalled "7zip"
Install-ChocoPackageIfNotInstalled "windirstat"

#Art:
Write-Host "Installing art related software. Please remember to install necessary dependencies and build Aseprite from source."
Install-ChocoPackageIfNotInstalled "paint.net"
#Install-ChocoPackageIfNotInstalled "cherrytree"
#Install-ChocoPackageIfNotInstalled "greenshot"
Install-ChocoPackageIfNotInstalled "gimp"
Install-ChocoPackageIfNotInstalled "krita"
Install-ChocoPackageIfNotInstalled "blender" 

#Productivity:
Write-Host "Installing productivity tools."
Install-ChocoPackageIfNotInstalled "obsidian"
Install-ChocoPackageIfNotInstalled "joplin"

#java:
#Install-ChocoPackageIfNotInstalled "openjdk"
#Install-ChocoPackageIfNotInstalled "javaruntime"

#Lib:
#SDL2
#zlib -> OpenTTD

Write-Host "Other software not included here: OneNote, Massgrave AS, Aseprite, Godot, Unreal."
Write-Host "Other dependencies not included here: Skia for Aseprite, Ninja Build, SDL2, Zlib."

# Prompt the user to see if they want to run the second script
$response = Read-Host "Do you want to install vcpkg to My Documents? (yes/no)"

# Check the user's response
if ($response -eq "y" -or $response -eq "yes") {
    # Run the second script
    Copy-Item -Path .\vcpkg_installer.ps1 -Destination "$env:USERPROFILE\Documents"
    & "$env:USERPROFILE\Documents\vcpkg_installer.ps1"
    Write-Host "script2.ps1 has been executed."
} else {
    Write-Host "Skipping vcpkg."
}

# Re-enable execution policy
Set-ExecutionPolicy Restricted -Scope Process -Force
