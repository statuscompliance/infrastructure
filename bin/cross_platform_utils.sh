#!/usr/bin/env bash

set -e

function needs_emulation() {
  arch=$(docker info --format '{{.Architecture}}')
  if [ "$arch" != "x86_64" ]; then
    return 0
  else
    return 1
  fi
}

function installBuildX() {
  if ! docker buildx version >/dev/null 2>&1; then
    echo "Docker Buildx is not installed. Installing..."
    docker buildx install
  else
    echo "Docker Buildx is already installed."
  fi
}

function setupCrossPlatformEnvironment() {
  if needs_emulation; then
    installBuildX
  fi
}

function getDockerCompose() {
  if needs_emulation; then
    echo "docker-compose-emulated.yml"
  else
    echo "docker-compose.yml"
  fi
}
