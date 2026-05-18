.PHONY: help build up down logs stop start reset clean logs-app logs-db exec-app exec-db backup restore ps

# Default target
help:
	@echo "Disha Nepal Career Intelligence Portal - Docker Commands"
	@echo ""
	@echo "Setup & Running:"
	@echo "  make build          - Build and start all containers (first time)"
	@echo "  make up             - Start containers in background"
	@echo "  make down           - Stop containers"
	@echo "  make restart        - Restart all containers"
	@echo "  make reset          - Stop and remove all containers/volumes (clean slate)"
	@echo ""
	@echo "Development:"
	@echo "  make logs           - Show live logs from all containers"
	@echo "  make logs-app       - Show logs from Java application"
	@echo "  make logs-db        - Show logs from MySQL database"
	@echo "  make ps             - Show container status"
	@echo ""
	@echo "Database:"
	@echo "  make exec-db        - Connect to MySQL shell"
	@echo "  make backup         - Backup database to backup.sql"
	@echo "  make restore        - Restore database from backup.sql"
	@echo ""
	@echo "Advanced:"
	@echo "  make exec-app       - Connect to application container shell"
	@echo "  make clean          - Remove all containers, images, and volumes"
	@echo ""
	@echo "Quick reference:"
	@echo "  Application:        http://localhost:8080"
	@echo "  Database Host:      localhost:3306"
	@echo "  Database User:      disha_user"
	@echo "  Database Password:  disha_pass"

# Build and start (first time)
build:
	@echo "Building and starting containers..."
	docker-compose up --build

# Start containers in background
up:
	@echo "Starting containers in background..."
	docker-compose up -d
	@echo ""
	@echo "✓ Containers started!"
	@echo "  Application: http://localhost:8080"
	@echo "  Database: localhost:3306"

# Stop containers
down:
	@echo "Stopping containers..."
	docker-compose down
	@echo "✓ Containers stopped"

# Restart containers
restart:
	@echo "Restarting containers..."
	docker-compose restart
	@echo "✓ Containers restarted"

# View live logs
logs:
	docker-compose logs -f

# View app logs
logs-app:
	docker-compose logs -f java-app

# View database logs
logs-db:
	docker-compose logs -f mysql-db

# Show container status
ps:
	docker-compose ps

# Connect to database shell
exec-db:
	docker-compose exec mysql-db mysql -u disha_user -pdisha_pass -D disha_db

# Connect to app shell
exec-app:
	docker-compose exec java-app /bin/bash

# Reset everything (clean slate)
reset:
	@echo "WARNING: This will delete all containers and data!"
	@read -p "Are you sure? (y/n) " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "Removing all containers and volumes..."; \
		docker-compose down -v; \
		echo "✓ Everything cleaned up"; \
	else \
		echo "Cancelled"; \
	fi

# Backup database
backup:
	@echo "Backing up database to backup.sql..."
	docker-compose exec mysql-db mysqldump -u root -proot_password disha_db > backup.sql
	@echo "✓ Backup saved to backup.sql"

# Restore database
restore:
	@echo "Restoring database from backup.sql..."
	docker-compose exec -T mysql-db mysql -u root -proot_password disha_db < backup.sql
	@echo "✓ Database restored"

# Clean everything (containers, images, volumes)
clean:
	@echo "WARNING: This will delete all Docker data for this project!"
	@read -p "Are you sure? (y/n) " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "Removing containers, images, and volumes..."; \
		docker-compose down -v --rmi all; \
		echo "✓ Everything cleaned"; \
	else \
		echo "Cancelled"; \
	fi
