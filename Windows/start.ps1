# Halts the script as soon as an error is detected
$ErrorActionPreference = "Stop"

Write-Host "Building and starting the images..."

docker compose -f ../docker-compose.yml --env-file ../.env up --wait
