# Halts the script as soon as an error is detected
$ErrorActionPreference = "Stop"

Write-Host "_______________________INITIAL DATA_______________________"

# Disable SSL verification
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Define JSON payload for sign in
$jsonBodySignIn = @{
    username = $username
    password = $passwordPlainText
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri "http://localhost:3001/api/user/signIn" -Method POST -ContentType "application/json" -Body $jsonBodySignIn -UseBasicParsing
$accessToken = ($response.Content | ConvertFrom-Json).accessToken

Write-Host "Token JWT: $accessToken"

$baseUrl = "http://localhost:3001/api/v1/grafana"
$envFile = "..\.env"

$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type" = "application/json"
}

$serviceAccountPayload = @{
    name = "Status system"
    role = "Admin"
} | ConvertTo-Json

$responseServiceAccount = Invoke-WebRequest -Uri "$baseUrl/serviceaccount" -Method POST -Headers $headers -Body $serviceAccountPayload -UseBasicParsing
$serviceAccountId = ($responseServiceAccount.Content | ConvertFrom-Json).id

if (-not $serviceAccountId) {
    Write-Host "Error: No se pudo obtener el ID del Service Account"
    exit 1
}

$tokenPayload = @{
    name = "STATUS System Token"
} | ConvertTo-Json

$responseToken = Invoke-WebRequest -Uri "$baseUrl/serviceaccount/$serviceAccountId/token" -Method POST -Headers $headers -Body $tokenPayload -UseBasicParsing
$tokenKey = ($responseToken.Content | ConvertFrom-Json).key

if (-not $tokenKey) {
    Write-Host "Error: No se pudo obtener el token"
    exit 1
}

(Get-Content $envFile) -replace '^(GRAFANA_API_KEY=).*', "`$1$tokenKey" | Set-Content $envFile

Write-Host "Grafana API Key: $tokenKey"
