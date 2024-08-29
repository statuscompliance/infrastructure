# Halts the script as soon as an error is detected
$ErrorActionPreference = "Stop"

Write-Host "Stopping containers..."

docker compose -f ..\docker-compose.yml down
