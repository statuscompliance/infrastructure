#!/usr/bin/env bash

set -e

## Compare versions
version_greater_equal() {
    printf '%s\n%s' "$2" "$1" | sort -C -V
}

## Check if Docker is installed
docker_version=$(docker --version | awk '{print $3}' | sed 's/,//')
required_version="21.0.0"

if version_greater_equal "$docker_version" "$required_version"; then
    echo "Docker version $docker_version is compatible"
else
    echo Docker version $docker_version is incompatible. At least version $required_version is required.
    exit 1
fi

echo ""

## Clean up previous installations
directories=("node-red-status" ".env" "settings.js")

for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        echo "Deleting $dir..."
        rm -rf "$dir"
    fi
done

echo ""

## If a folder is not created before doing a bind mount in Docker, the folder will be created with root permissions only.
mkdir -p node-red-status

# Create a default flows.js file if it doesn't exist
DEFAULT_FLOWS_SOURCE="./config/default_flows.json"
FLOWS_DESTINATION="./node-red-status/flows.json"

if [ -f "$DEFAULT_FLOWS_SOURCE" ]; then
    if [ ! -f "$FLOWS_DESTINATION" ]; then
        echo "Copying default Node-RED flows from '$DEFAULT_FLOWS_SOURCE' to '$FLOWS_DESTINATION'..."
        cp "$DEFAULT_FLOWS_SOURCE" "$FLOWS_DESTINATION"
    else
        echo "Node-RED flows file ($FLOWS_DESTINATION) already exists. Skipping copy of default file."
    fi
else
    echo "Warning: Default Node-RED flows file '$DEFAULT_FLOWS_SOURCE' not found. No default flows will be loaded."
fi

## Ask if default user credentials should be used
echo "_______________________USER CONFIGURATION_______________________"
read -p "Do you want to use the default user (admin/admin123)? (y/n): " use_default

if [ "$use_default" = "y" ] || [ "$use_default" = "Y" ]; then
    username="admin"
    password="admin123"
    email="admin@example.com"
    echo "Using default credentials: username=$username, email=$email"
else
    ## Create a new user and password for Node-RED
    echo "_______________________CREATE YOUR USER_______________________"
    read -p "Enter a new username: " username
    read -s -p "Enter a new password: " password
    echo
    read -p "Enter your email: " email
    echo # newline
fi

# Hash the password
docker pull epicsoft/bcrypt > /dev/null 2>&1
encrypted_password=$(docker run --rm epicsoft/bcrypt hash "$password" 12)
docker rmi epicsoft/bcrypt > /dev/null 2>&1

function setVariables() {
  local contents

  contents=$(< settings_template.js)
  contents="${contents//\"example_user\"/\"$username\"}"
  contents="${contents//\"example_pass\"/\"$encrypted_password\"}"

  echo "$contents" > settings.js

  contents=$(< .env.deploy)
  contents="${contents//example_user/$username}"
  contents="${contents//example_pass/$password}"

  echo "$contents" > .env
}

setVariables

echo "Node-RED user created successfully."
echo ""
