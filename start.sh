#!/usr/bin/env bash

source bin/cross_platform_utils.sh

setupCrossPlatformEnvironment
compose_file=$(getDockerCompose)

echo "Starting the containers on $compose_file..."
echo ""

docker compose -f $compose_file up --wait 
