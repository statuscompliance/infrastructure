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

Write-Host "Building and starting the images..."

docker compose -f ../docker-compose.yml --env-file ../.env up --wait
