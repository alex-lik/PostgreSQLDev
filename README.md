# Docker Compose Setup with PostgreSQL, pgAdmin, and Adminer

This setup provides a complete PostgreSQL development environment with both pgAdmin and Adminer for database management.

## Services

- **PostgreSQL**: Database server running on port 5434
- **pgAdmin**: Web-based PostgreSQL administration tool running on port 5050
- **Adminer**: Lightweight database management tool running on port 8080

## Setup

1. Make sure you have Docker and Docker Compose installed
2. Run the services using:
   ```bash
   docker-compose up -d
   ```

## Accessing the Services

### PostgreSQL
- Host: localhost
- Port: 5432
- Multiple databases created: db1, db2, db3
- Username: postgres
- Password: postgres

### pgAdmin
- URL: http://localhost:5050
- Email: admin@admin.com
- Password: admin

To connect pgAdmin to the PostgreSQL server:
1. Add a new server
2. Host: postgresql (use the service name, not localhost)
3. Username: postgres
4. Password: postgres

### Adminer
- URL: http://localhost:8080
- System: PostgreSQL
- Server: postgresql (use the service name, not localhost)
- Username: postgres
- Password: postgres
- Databases: db1, db2, db3

## Volumes

- `postgres_data`: Persists PostgreSQL data
- `pgadmin_data`: Persists pgAdmin configuration

## Stopping the Services

```bash
docker-compose down
```

To stop and remove volumes (this will delete all data):
```bash
docker-compose down -v
```