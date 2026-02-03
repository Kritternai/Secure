# Ensure pentest-net exists, then start Mutillidae stack
$null = docker network create pentest-net 2>$null
docker-compose up -d
Write-Host ""
Write-Host "Mutillidae: http://localhost"
Write-Host "phpMyAdmin: http://localhost:81"
Write-Host "phpLDAPAdmin: http://localhost:82"
