#!/usr/bin/env bash

set -e

echo ""
echo "_______________________INITIAL DATA_______________________"

curl -s -X GET http://localhost:3001/api/user > /dev/null 2>&1

## Create a new user
curl -s -X POST http://localhost:3001/api/user/signUp \
     -H "Content-Type: application/json" \
     -d "{ \"username\": \"${username}\", \"password\": \"${password}\", \"authority\": \"ADMIN\", \"email\": \"${email}\" }" > /dev/null 2>&1


## Sign in to get the access token
token=$(curl -s -X POST http://localhost:3001/api/user/signIn \
     -H "Content-Type: application/json" \
     -d "{ \"username\": \"${username}\", \"password\": \"${password}\" }" | jq -r '.accessToken')

echo "Token JWT: $token"
