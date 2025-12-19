# Halts the script as soon as an error is detected
$ErrorActionPreference = "Stop"

# Require an interactive selection
while ($true) {
    $MODE = Read-Host "Select mode [dev|prod] (default: dev)"
    if ([string]::IsNullOrWhiteSpace($MODE)) {
        $MODE = "dev"
    }
    
    switch ($MODE.ToLower()) {
        {$_ -in "dev", "development"} {
            $COMPOSE_FILE = "..\docker-compose.dev.yml"
            $START_MSG = "Starting containers in development mode using docker-compose.dev.yml..."
            $ACCESS_URL = "http://localhost:3000"
            $env:NODE_ENV = "development"
            $env:ALLOWED_ORIGINS = "http://localhost:3000,http://localhost:5173"
            break
        }
        {$_ -in "prod", "production"} {
            $COMPOSE_FILE = "..\docker-compose.prod.yml"
            $START_MSG = "Starting containers in production mode using docker-compose.prod.yml..."
            $ACCESS_URL = "http://localhost:3000"
            $env:NODE_ENV = "production"
            ## TODO: Update these origins to match STATUS production domains
            $env:ALLOWED_ORIGINS = "https://app.status.com,https://www.status.com"
            break
        }
        default {
            Write-Host "Please enter 'dev' or 'prod'."
            continue
        }
    }
    break
}

Write-Host @"
                            WELCOME TO
  ______   _________     _     _________  _____  _____   ______
.' ____ \ |  _   _  |   / \   |  _   _  ||_   _||_   _|.' ____ \
| (___ \_||_/ | | \_|  / _ \  |_/ | | \_|  | |    | |  | (___ \_|
 _.____`.     | |     / ___ \     | |      | '    ' |   _.____`.
| \____) |   _| |_  _/ /   \ \_  _| |_      \ \__/ /   | \____) |
 \______.'  |_____||____| |____||_____|      `.__.'     \______.'

"@

## Step 1: Prepare the environment
. .\prepare_environment.ps1

## Step 2: Build and start the containers
Write-Host $START_MSG
Write-Host ""

docker compose -f $COMPOSE_FILE up --wait

## Step 3: Populate the database with initial data
Write-Host "Populating the database with initial data..."
try {
    docker exec status-backend npm run populate
} catch {
    Write-Host "Warning: Failed to populate database, continuing..."
}

## Step 4: Insert initial data
try {
    . .\initial_data.ps1
} catch {
    Write-Host "Warning: Failed to insert initial data, continuing..."
}

Write-Host "Infrastructure up and running successfully."
Write-Host "You can access the application at $ACCESS_URL"

