# Halts the script as soon as an error is detected
$ErrorActionPreference = "Stop"

Write-Host "_______________________INITIAL DATA_______________________"

# Disable SSL verification
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Make GET request to retrieve user information
Invoke-WebRequest -Uri "http://localhost:3001/api/user" -Method GET -UseBasicParsing | Out-Null

# Define JSON payload for creating a new user
$jsonBodySignUp = @{
    username = $username
    password = $password
    authority = "ADMIN"
    email = $email
} | ConvertTo-Json

# Make POST request to create a new user
Invoke-WebRequest -Uri "http://localhost:3001/api/user/signUp" -Method POST -ContentType "application/json" -Body $jsonBodySignUp -UseBasicParsing | Out-Null

# Sign in to get the access token
$jsonBodySignIn = @{
    username = $username
    password = $password
} | ConvertTo-Json
$response = Invoke-WebRequest -Uri "http://localhost:3001/api/user/signIn" -Method POST -ContentType "application/json" -Body $jsonBodySignIn -UseBasicParsing
$accessToken = ($response.Content | ConvertFrom-Json).accessToken

Write-Host "Token JWT: $accessToken"
