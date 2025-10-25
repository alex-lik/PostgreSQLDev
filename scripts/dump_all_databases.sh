#!/bin/bash

# Script to dump all PostgreSQL databases
# Assumes PostgreSQL container is named 'postgresql_db' as in your docker-compose.yml

echo "Starting database dump process..."

# Set default values
CONTAINER_NAME="postgresql_db"
PG_USER="postgres"
PG_PASSWORD="postgres"
BACKUP_DIR="./backup"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Get the current date for backup naming
DATE=$(date +%Y%m%d_%H%M%S)

echo "Connecting to PostgreSQL container: $CONTAINER_NAME"

# Get list of all databases (excluding template databases)
DATABASES=$(docker exec $CONTAINER_NAME psql -U $PG_USER -t -c "SELECT datname FROM pg_database WHERE datistemplate = false AND datname != 'postgres';" | xargs)

echo "Found databases: $DATABASES"

# Loop through each database and create a dump
for db in $DATABASES; do
    if [ ! -z "$db" ]; then
        echo "Dumping database: $db"
        DUMP_FILE="$BACKUP_DIR/${db}_${DATE}.sql"
        
        # Perform the dump
        docker exec $CONTAINER_NAME pg_dump -U $PG_USER -d $db > "$DUMP_FILE"
        
        # Check if dump was successful
        if [ $? -eq 0 ]; then
            echo "Successfully dumped $db to $DUMP_FILE"
        else
            echo "Failed to dump $db"
        fi
    fi
done

echo "Database dump process completed!"
echo "Backups are stored in: $BACKUP_DIR"