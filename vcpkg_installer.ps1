# PowerShell Script to Clone, Bootstrap vcpkg, Set Environment Variables, and Update PATH
Set-ExecutionPolicy Bypass -Scope Process -Force
# Function to display messages in different colors
function Write-Color {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to prompt and confirm the installation directory
function Confirm-InstallationDirectory {
    Write-Color "Current Directory: $(Get-Location)" -Color Cyan
    $response = Read-Host "Are you in the directory where you want to install vcpkg? (Y/N)"

    Process-Response $response
}

# Function to process the user's response
function Process-Response {
    param (
        [string]$Input
    )
    switch ($Input.ToLower()) {
        'y' {
            Clone-And-Bootstrap
            break
        }
        'yes' {
            Clone-And-Bootstrap
            break
        }
        'n' {
            Write-Color "Please navigate to the desired directory and run the script again." -Color Yellow
            exit
            break
        }
        'no' {
            Write-Color "Please navigate to the desired directory and run the script again." -Color Yellow
            exit
            break
        }
        default {
            Write-Color "Invalid input. Please enter Y or N." -Color Red
            $newResponse = Read-Host "Are you in the directory where you want to install vcpkg? (Y/N)"
            Process-Response $newResponse
        }
    }
}

# Function to clone and bootstrap vcpkg
function Clone-And-Bootstrap {
    # Define the vcpkg repository URL
    $vcpkgRepo = "https://github.com/microsoft/vcpkg.git"
    $vcpkgDir = "vcpkg"

    # Check if vcpkg directory already exists
    if (Test-Path $vcpkgDir) {
        Write-Color "vcpkg directory already exists in the current location." -Color Yellow
        $overwrite = Read-Host "Do you want to delete the existing vcpkg directory and clone again? (Y/N)"
        switch ($overwrite.ToLower()) {
            'y' {
                Remove-Item -Recurse -Force $vcpkgDir
                Write-Color "Existing vcpkg directory removed." -Color Green
                CloneRepository
                break
            }
            'yes' {
                Remove-Item -Recurse -Force $vcpkgDir
                Write-Color "Existing vcpkg directory removed." -Color Green
                CloneRepository
                break
            }
            'n' {
                Write-Color "Skipping cloning. Exiting script." -Color Yellow
                exit
                break
            }
            'no' {
                Write-Color "Skipping cloning. Exiting script." -Color Yellow
                exit
                break
            }
            default {
                Write-Color "Invalid input. Exiting script." -Color Red
                exit
            }
        }
    }
    else {
        CloneRepository
    }
}

# Function to clone the repository
function CloneRepository {
    Write-Color "Cloning vcpkg repository from $vcpkgRepo ..." -Color Green
    try {
        git clone $vcpkgRepo
        Write-Color "vcpkg repository cloned successfully." -Color Green
        Bootstrap-Vcpkg
    }
    catch {
        Write-Color "Error cloning repository: $_" -Color Red
        exit
    }
}

# Function to bootstrap vcpkg
function Bootstrap-Vcpkg {
    Write-Color "Bootstrapping vcpkg..." -Color Green
    try {
        Push-Location "vcpkg"
        if (Test-Path ".\bootstrap-vcpkg.bat") {
            .\bootstrap-vcpkg.bat
            Write-Color "vcpkg bootstrapped successfully." -Color Green
            Write-Color "vcpkg is ready to use!" -Color Cyan
            # After successful bootstrap, set environment variables
            Set-EnvironmentVariables
        }
        else {
            Write-Color "bootstrap-vcpkg.bat not found in the vcpkg directory." -Color Red
        }
    }
    catch {
        Write-Color "Error during bootstrapping: $_" -Color Red
    }
    finally {
        Pop-Location
    }
}

# Function to set environment variables and update PATH
function Set-EnvironmentVariables {
    $vcpkgPath = (Resolve-Path "vcpkg").Path

    # Set the VCPKG_ROOT environment variable for the current user
    Write-Color "Setting 'VCPKG_ROOT' environment variable to '$vcpkgPath'..." -Color Green
    [System.Environment]::SetEnvironmentVariable("VCPKG_ROOT", $vcpkgPath, [System.EnvironmentVariableTarget]::User)

    # Verify if VCPKG_ROOT has been set correctly
    $existingVcpkgRoot = [System.Environment]::GetEnvironmentVariable("VCPKG_ROOT", [System.EnvironmentVariableTarget]::User)
    if ($existingVcpkgRoot -eq $vcpkgPath) {
        Write-Color "'VCPKG_ROOT' has been set successfully." -Color Green
    }
    else {
        Write-Color "Failed to set 'VCPKG_ROOT'." -Color Red
    }

    # Add vcpkg to the user's PATH
    $currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
    if (-not ($currentPath.Split(';') -contains $vcpkgPath)) {
        Write-Color "Adding '$vcpkgPath' to PATH..." -Color Green
        $newPath = "$currentPath;$vcpkgPath"
        [System.Environment]::SetEnvironmentVariable("PATH", $newPath, [System.EnvironmentVariableTarget]::User)
        Write-Color "'vcpkg' has been added to your PATH successfully." -Color Green
    }
    else {
        Write-Color "'vcpkg' path is already in PATH." -Color Yellow
    }

    # Confirm the changes
    Write-Color "`nEnvironment Variable 'VCPKG_ROOT': $($env:VCPKG_ROOT)" -Color Cyan
    Write-Color "Current User PATH:" -Color Cyan
    Write-Color $([Environment]::GetEnvironmentVariable("PATH", "User")) -Color White

    Write-Color "`nEnvironment setup is complete. You may need to restart your PowerShell session or log out and log back in for changes to take full effect." -Color Yellow
}

# Start the script by confirming the installation directory
Confirm-InstallationDirectory
Set-ExecutionPolicy Restricted -Scope Process -Force
