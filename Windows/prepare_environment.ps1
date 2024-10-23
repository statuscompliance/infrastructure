# Halts the script as soon as an error is detected
$ErrorActionPreference = "Stop"

# Function to compare versions
function Compare-Versions {
    param (
        [string]$version1,
        [string]$version2
    )

    # Replace dots with spaces
    $version1 = $version1 -replace '\.', ' '
    $version2 = $version2 -replace '\.', ' '

    # Split versions into arrays
    $segments1 = $version1.Split(' ')
    $segments2 = $version2.Split(' ')

    # Initialize result
    $result = 0

    # Compare each segment
    for ($i = 0; $i -lt 4; $i++) {
        if ($segments1[$i] -gt $segments2[$i]) {
            $result = 1
            break
        }
        elseif ($segments1[$i] -lt $segments2[$i]) {
            $result = -1
            break
        }
    }

    return $result
}

# Start preparing environment
Write-Host "Preparing environment..."
# Check Docker installation
Write-Host "Checking Docker installation..."
$docker_version = & docker --version
$docker_version = $docker_version.Split(' ')[2] -replace ',', ''

$required_version = '21.0.0'

# Call Compare-Versions function
$result = Compare-Versions -version1 $docker_version -version2 $required_version

if ($result -eq -1) {
    Throw "Docker version $docker_version is incompatible. At least version $required_version is required."
}
else {
    Write-Host "Docker version $docker_version is compatible."
}

# Clean up previous installations
$directories = "status-backend", "status-frontend", "node-red-status", "mysql", "grafana"

foreach ($dir in $directories) {
    if (Test-Path "..\$dir") {
        Write-Host "Deleting $dir..."
        Remove-Item -Path "..\$dir" -Recurse -Force
    }
}

# Clone repositories
Write-Host "_______________________CLONING REPOSITORIES_______________________"

# git clone -b feature/33-Integrate_grafana https://github.com/statuscompliance/status-backend ..\status-backend
# git clone -b develop https://github.com/statuscompliance/status-frontend ..\status-frontend



# Create node-red-status directory if not exist
if (-not (Test-Path "..\node-red-status")) {
    New-Item -ItemType Directory -Path "..\node-red-status" | Out-Null
}
if (-not (Test-Path "..\status-backend")) {
    New-Item -ItemType Directory -Path "..\status-backend" | Out-Null
}

# Delete settings.js if exists and create new from settings_template.js
if (Test-Path "..\settings.js") {
    Write-Host "Deleting settings.js..."
    Remove-Item -Path "..\settings.js" -Force
}

Copy-Item ..\settings_template.js ..\settings.js

# Create a new user and password for Node-RED
Write-Host "_______________________CREATE YOUR USER_______________________"

$username = Read-Host "Enter a new username"
$password = Read-Host "Enter a new password" -AsSecureString
$email = Read-Host "Enter your email"

# Convert secure password to plain text
$passwordPlainText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

# Hash the password using bcrypt
$bcryptImage = 'epicsoft/bcrypt'
docker pull $bcryptImage > $null 2>&1
$hashedPassword = & docker run --rm $bcryptImage hash "$passwordPlainText" 10
docker rmi $bcryptImage > $null 2>&1

# Replace example_user and example_pass strings with new user and password in settings.js
(Get-Content "..\settings.js") -replace 'example_user', $username -replace 'example_pass', $hashedPassword | Set-Content "..\settings.js"
(Get-Content "..\.env.deploy") -replace 'example_user', $username -replace 'example_pass', $passwordPlainText | Set-Content "..\.env"

Copy-Item ..\.env ..\status-backend\.env

Write-Host "Node-RED user created successfully."
