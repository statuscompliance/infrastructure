Write-Host @"
                            WELCOME TO
  ______   _________     _     _________  _____  _____   ______
.' ____ \ |  _   _  |   / \   |  _   _  ||_   _||_   _|.' ____ \
| (___ \_||_/ | | \_|  / _ \  |_/ | | \_|  | |    | |  | (___ \_|
 _.____`.     | |     / ___ \     | |      | '    ' |   _.____`.
| \____) |   _| |_  _/ /   \ \_  _| |_      \ \__/ /   | \____) |
 \______.'  |_____||____| |____||_____|      `.__.'     \______.'
"@

# Halts the script as soon as an error is detected
$ErrorActionPreference = "Stop"

# Step 1: Prepare the environment
. .\prepare_environment.ps1

# Step 2: Build and start the containers
$ErrorActionPreference = "Stop"

Write-Host "Building and starting the images..."

docker compose -f ../docker-compose.yml --env-file ../.env up --wait

# Step 3: Populate the database with initial data
Write-Host "Populating the database with initial data..."
docker exec status-backend npm run populate

# Step 4: Insert initial data
. .\initial_data.ps1

Write-Host "Infrastructure up and running successfully."
Write-Host "You can access the application at http://localhost:3000"

