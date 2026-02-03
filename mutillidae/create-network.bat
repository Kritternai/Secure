@echo off
REM Create external Docker network for Mutillidae (required before docker-compose up)
docker network create pentest-net 2>nul
if %errorlevel% equ 0 (
    echo Network pentest-net created.
) else (
    echo Network pentest-net already exists or created.
)
pause
