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
directories=("status-backend" "frontend" "node-red-status" "grafana" ".env")

for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        echo "Deleting $dir..."
        rm -rf "$dir"
    fi
done

echo ""


## If a folder is not created before doing a bind mount in Docker, the folder will be created with root permissions only.
mkdir -p node-red-status

## If a settings.js file exists, delete it and create a new one from settings_template.js
if [ -f "settings.js" ]; then
    echo "Deleting settings.js..."
    rm settings.js
fi

cp settings_template.js settings.js

## Create a new user and password for Node-RED

echo "_______________________CREATE YOUR USER_______________________"
read -p "Enter a new username: " username
read -s -p "Enter a new password: " password
echo
read -p "Enter your email: " email
echo # newline

# Hash the password
docker pull epicsoft/bcrypt > /dev/null 2>&1
encrypted_password=$(docker run --rm epicsoft/bcrypt hash "$password" 10 | sed -e 's/[\/&]/\\&/g')
docker rmi epicsoft/bcrypt > /dev/null 2>&1

## Replace the example_user and example_pass strings with the new user and password
## Due to differences in GNU and Mac implementations, we don't do it in place

function setVariables() {
    local output
    output=$(sed -e "s/\"example_user\"/\"$username\"/g" settings.js)
    echo "$output" > settings.js
    output=$(sed -e "s/\"example_pass\"/\"$encrypted_password\"/g" settings.js)
    echo "$output" > settings.js

    output=$(sed -e "s/example_user/$username/g" .env.deploy)
    echo "$output" > .env
    output=$(sed -e "s/example_pass/$password/g" .env)
    echo "$output" > .env

    output=$(sed -e "s/example_user/$username/g" ./config/init.sql)
    output=$(echo "$output" | sed -e "s/example_pass/$encrypted_password/g")
    output=$(echo "$output" | sed -e "s/email_example/$email/g")
    echo "$output" > ./config/init.sql
}

setVariables

echo "Node-RED user created successfully."
echo ""
