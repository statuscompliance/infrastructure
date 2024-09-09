#!/usr/bin/env pwsh

Write-Host "_______________________UPDATING INFRASTRUCTURE_______________________"

$SCRIPT_DIR = (Get-Location).Path
$BASE_DIR = Split-Path -Parent $SCRIPT_DIR

function Check-LocalChanges {
    param (
        [string]$dir
    )

    $repo_path = Join-Path -Path $BASE_DIR -ChildPath $dir

    if (-Not (Test-Path -Path $repo_path -PathType Container)) {
        Write-Host "Directory $repo_path does not exist. Skipping..."
        return
    }

    Set-Location -Path $repo_path

    git update-index -q --refresh

    if (git status --porcelain) {
        Write-Host "Local changes detected in $dir. Please commit, stash, or discard your changes before updating."
        exit 1
    }

    Set-Location -Path $SCRIPT_DIR
}

function Check-RepoUpdates {
    param (
        [string]$dir
    )

    $repo_path = Join-Path -Path $BASE_DIR -ChildPath $dir

    if (-Not (Test-Path -Path $repo_path -PathType Container)) {
        Write-Host "Directory $repo_path does not exist. Skipping..."
        return
    }

    Set-Location -Path $repo_path

    $current_branch = git branch --show-current

    git fetch

    if ((git rev-parse HEAD) -ne (git rev-parse "@{u}")) {
        Write-Host "Changes detected in $dir, updating..."
        git pull origin $current_branch
        return $true
    } else {
        Write-Host "No changes detected in $dir."
        return $false
    }

    Set-Location -Path $SCRIPT_DIR
}

$rebuild_required = $false

$repos = @("status-backend", "status-frontend", "reporter", "collector-events")

foreach ($repo in $repos) {
    Check-LocalChanges -dir $repo
}

foreach ($repo in $repos) {
    if (Check-RepoUpdates -dir $repo) {
        $rebuild_required = $true
    }
}

if ($rebuild_required) {
    Write-Host "_______________________REBUILDING CONTAINERS_______________________"

    . "$BASE_DIR\Windows\bin\cross_platform_utils.ps1"
    Setup-CrossPlatformEnvironment
    $compose_file = Get-DockerCompose

    docker compose -f $compose_file build

    Write-Host "Restarting updated containers..."
    docker compose -f $compose_file up -d --remove-orphans
} else {
    Write-Host "No updates detected. Infrastructure is up-to-date."
}

Write-Host "Update process completed successfully."

