#!/usr/bin/env bash

source bin/cross_platform_utils.sh

setupCrossPlatformEnvironment
compose_file="docker-compose.yml"

echo "Stopping containers on $compose_file..."
echo ""

docker compose -f $compose_file down
