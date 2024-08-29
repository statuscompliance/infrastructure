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

## Step 1: Prepare the environment
source bin/prepare_environment.sh

## Step 2: Build and start the containers
source start.sh

## Step 3: Insert initial data
source bin/initial_data.sh

echo "Infrastructure up and running successfully."
echo "You can access the application at http://localhost:3000/login"
