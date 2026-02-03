# Create external Docker network for Mutillidae (required before docker-compose up)
$network = "pentest-net"
$exists = docker network inspect $network 2>$null
if ($LASTEXITCODE -ne 0) {
    docker network create $network
    Write-Host "Network $network created."
} else {
    Write-Host "Network $network already exists."
}
