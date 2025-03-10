#!/usr/bin/env bash

set -e

echo "_______________________UPDATING INFRASTRUCTURE_______________________"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

check_local_changes() {
  local dir=$1
  local repo_path="$SCRIPT_DIR/$dir"
  
  if [ ! -d "$repo_path" ]; then
    echo "Directory $repo_path does not exist. Skipping..."
    return
  fi

  cd "$repo_path"

  git update-index -q --refresh

  if [ -n "$(git status --porcelain)" ]; then
    echo "Local changes detected in $dir. Please commit, stash, or discard your changes before updating."
    exit 1 
  fi
  cd "$SCRIPT_DIR"
}

check_repo_updates() {
  local dir=$1
  local repo_path="$SCRIPT_DIR/$dir"
  
  if [ ! -d "$repo_path" ]; then
    echo "Directory $repo_path does not exist. Skipping..."
    return
  fi

  cd "$repo_path"

  current_branch=$(git branch --show-current)

  git fetch

  if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
    echo "Changes detected in $dir, updating..."
    git pull origin "$current_branch"
    return 0  
  else
    echo "No changes detected in $dir."
    return 1  
  fi
  cd "$SCRIPT_DIR"
}

rebuild_required=false

repos=("status-backend" "status-frontend" "reporter" "collector-events")

for repo in "${repos[@]}"; do
  check_local_changes "$repo"
done

for repo in "${repos[@]}"; do
  if check_repo_updates "$repo"; then
    rebuild_required=true
  fi
done


if [ "$rebuild_required" = true ]; then
  echo "_______________________REBUILDING CONTAINERS_______________________"

  source bin/cross_platform_utils.sh
  setupCrossPlatformEnvironment
  compose_file="docker-compose.yml"

  docker compose -f $compose_file build

  echo "Restarting updated containers..."
  docker compose -f $compose_file up -d --remove-orphans
else
  echo "No updates detected. Infrastructure is up-to-date."
fi

echo "Update process completed successfully."
