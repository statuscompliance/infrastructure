#!/usr/bin/env bash

cat << "EOF"
                            WELCOME TO 
  ______   _________     _     _________  _____  _____   ______   
.' ____ \ |  _   _  |   / \   |  _   _  ||_   _||_   _|.' ____ \  
| (___ \_||_/ | | \_|  / _ \  |_/ | | \_|  | |    | |  | (___ \_| 
 _.____`.     | |     / ___ \     | |      | '    ' |   _.____`.  
| \____) |   _| |_  _/ /   \ \_  _| |_      \ \__/ /   | \____) | 
 \______.'  |_____||____| |____||_____|      `.__.'     \______.' 
                                                                                                    
EOF

source bin/cross_platform_utils.sh

setupCrossPlatformEnvironment
compose_file=$(getDockerCompose)

echo "Starting the containers on $compose_file..."
echo ""

docker compose -f $compose_file up --wait
