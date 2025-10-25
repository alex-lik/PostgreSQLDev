@echo off
setlocal enabledelayedexpansion

REM Script to dump all PostgreSQL databases
REM Assumes PostgreSQL container is named 'postgresql_db' as in your docker-compose.yml

echo Starting database dump process...

REM Set default values
set CONTAINER_NAME=postgresql_db
set PG_USER=postgres
set PG_PASSWORD=postgres
set BACKUP_DIR=.\backup

REM Create backup directory if it doesn't exist
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

REM Get the current date for backup naming (format: YYYYMMDD_HHMMSS)
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "date=!dt:~0,4!!dt:~4,2!!dt:~6,2!_!dt:~8,2!!dt:~10,2!!dt:~12,2!"

echo Connecting to PostgreSQL container: !CONTAINER_NAME!

REM Get list of all databases (excluding template databases)
for /f "skip=2 tokens=*" %%i in ('docker exec !CONTAINER_NAME! psql -U !PG_USER! -t -c "SELECT datname FROM pg_database WHERE datistemplate = false AND datname != 'postgres';"') do (
    set "db=%%i"
    if not "!db!"=="" (
        echo Dumping database: !db!
        set "DUMP_FILE=!BACKUP_DIR!\!db!_!date!.sql"
        
        REM Perform the dump
        docker exec !CONTAINER_NAME! pg_dump -U !PG_USER! -d !db! > "!DUMP_FILE!"
        
        REM Check if dump was successful
        if !errorlevel! equ 0 (
            echo Successfully dumped !db! to !DUMP_FILE!
        ) else (
            echo Failed to dump !db!
        )
    )
)

echo Database dump process completed!
echo Backups are stored in: !BACKUP_DIR!