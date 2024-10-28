#!/usr/bin/env bash

set -e

echo ""
echo "_______________________INITIAL DATA_______________________"

curl -s -X POST http://localhost:3001/api/user/signUp \
     -H "Content-Type: application/json" \
     -d "{ \"username\": \"${username}\", \"password\": \"${password}\", \"authority\": \"ADMIN\", \"email\": \"${email}\" }" > /dev/null 2>&1

token_payload=$(curl -s -X POST http://localhost:3001/api/user/signIn \
     -H "Content-Type: application/json" \
     -d "{ \"username\": \"${username}\", \"password\": \"${password}\" }")

docker pull linuxserver/yq > /dev/null 2>&1
token=$(docker run --rm --entrypoint jq --env JSON_DATA="$token_payload" linuxserver/yq -r -n "env.JSON_DATA | fromjson.accessToken")

echo "Token JWT: $token"

BASE_URL="http://localhost:3001/api/grafana"
ENV_FILE="../status-backend/.env"

RESPONSE=$(curl -s -X POST "${BASE_URL}/serviceaccount" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
        "name": "Status system",
        "role": "Admin"
      }')

SERVICE_ACCOUNT_ID=$(docker run --rm --entrypoint jq --env JSON_DATA="$RESPONSE" linuxserver/yq -r -n "env.JSON_DATA | fromjson.id")

if [ -z "$SERVICE_ACCOUNT_ID" ]; then
  echo "Error: No se pudo obtener el ID del Service Account"
  exit 1
fi

# Crear un nuevo token para la cuenta de servicio
TOKEN_RESPONSE=$(curl -s -X POST "${BASE_URL}/serviceaccount/${SERVICE_ACCOUNT_ID}/token" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
        "name": "STATUS System Token"
      }')

TOKEN_KEY=$(docker run --rm --entrypoint jq --env JSON_DATA="$TOKEN_RESPONSE" linuxserver/yq -r -n "env.JSON_DATA | fromjson.key")

if [ -z "$TOKEN_KEY" ]; then
  echo "Error: No se pudo obtener el token"
  exit 1
fi

sed -i.bak "s/^GRAFANA_API_KEY=.*/GRAFANA_API_KEY=$TOKEN_KEY/" "$ENV_FILE"
rm "$ENV_FILE.bak"

echo "Grafana API Key: $TOKEN_KEY"
docker rmi linuxserver/yq > /dev/null 2>&1