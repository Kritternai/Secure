@echo off
REM Ensure pentest-net exists, then start Mutillidae stack
docker network create pentest-net 2>nul
docker-compose up -d
echo.
echo Mutillidae: http://localhost
echo phpMyAdmin: http://localhost:81
echo phpLDAPAdmin: http://localhost:82
pause
