@echo off
REM Start Mutillidae stack (Docker Hub images) - run from this folder
docker-compose up -d
echo.
echo Mutillidae: http://localhost
echo phpMyAdmin: http://localhost:81
echo phpLDAPAdmin: http://localhost:82
echo Kali GUI: https://localhost:6901 (user: kasm_user, pass: password)
pause
