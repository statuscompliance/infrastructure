#!/usr/bin/env bash

set -euo pipefail

# Require an interactive selection. This script does not accept command-line
# arguments anymore — the user must choose between dev and prod interactively.
if [ -t 0 ]; then
  while true; do
    read -r -p "Select mode [dev|prod] (default: dev): " MODE
    MODE="${MODE:-dev}"
    case "$MODE" in
      dev|development)
        COMPOSE_FILE="docker-compose.dev.yml"
        START_MSG="Starting containers in development mode using ${COMPOSE_FILE}..."
        ACCESS_URL="http://localhost:3000"
        export NODE_ENV="development"
        export ALLOWED_ORIGINS="http://localhost:3000,http://localhost:5173"
        break
        ;;
      prod|production)
        COMPOSE_FILE="docker-compose.prod.yml"
        START_MSG="Starting containers in production mode using ${COMPOSE_FILE}..."
        ACCESS_URL="http://localhost:3000"
        export NODE_ENV="production"
        ## TODO: Update these origins to match STATUS production domains
        export ALLOWED_ORIGINS="https://app.status.com,https://www.status.com"
        break
        ;;
      *)
        echo "Please enter 'dev' or 'prod'."
        ;;
    esac
  done
else
  echo "This script requires an interactive terminal. Run it from a TTY." >&2
  exit 1
fi

cat << "EOF"
                            WELCOME TO 
  ______   _________     _     _________  _____  _____   ______   
." ____ \ |  _   _  |   / \   |  _   _  ||_   _||_   _|.' ____ \  
| (___ \_||_/ | | \_|  / _ \  |_/ | | \_|  | |    | |  | (___ \_| 
 _.____`.     | |     / ___ \     | |      | '    ' |   _.____`.  
| \____) |   _| |_  _/ /   \ \_  _| |_      \ \__/ /   | \____) | 
 \______.'  |_____||____| |____||_____|      `.__.'     \______.' 
                                                                    
EOF

## Step 1: Prepare the environment
source bin/prepare_environment.sh

## Step 2: Build and start the containers
echo "${START_MSG}"
echo ""

docker compose -f "${COMPOSE_FILE}" up --wait

## Step 3: Populate the database with initial data
echo "Populating the database with initial data..."
docker exec status-backend npm run populate || true

## Step 4: Insert initial data
source bin/initial_data.sh || true

echo "Infrastructure up and running successfully."
echo "You can access the application at ${ACCESS_URL}"
