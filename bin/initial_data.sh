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
token_payload=$(curl -s -X POST http://localhost:3001/api/user/signIn \
     -H "Content-Type: application/json" \
     -d "{ \"username\": \"${username}\", \"password\": \"${password}\" }")
docker pull linuxserver/yq > /dev/null 2>&1
token=$(docker run --rm --entrypoint jq --env JSON_DATA="$token_payload" linuxserver/yq -r -n "env.JSON_DATA | fromjson.accessToken")
docker rmi linuxserver/yq > /dev/null 2>&1

echo "Token JWT: $token"
