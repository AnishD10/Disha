@echo off
REM Quick setup script for Disha project (Windows)

echo ================================
echo Disha Nepal Career Intelligence
echo Docker Setup Script
echo ================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo X Docker is not installed!
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo + Docker is installed

REM Check if Docker daemon is running
docker info >nul 2>&1
if errorlevel 1 (
    echo X Docker daemon is not running!
    echo Please start Docker Desktop and try again
    pause
    exit /b 1
)

echo + Docker daemon is running
echo.

REM Ask user what to do
echo What would you like to do?
echo 1. Start containers (fresh build)
echo 2. Start containers (quick start)
echo 3. Stop containers
echo 4. View logs
echo 5. Reset everything (delete data)
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo.
    echo Starting: Building and starting containers...
    docker-compose up --build
) else if "%choice%"=="2" (
    echo.
    echo Starting: Starting containers...
    docker-compose up -d
    echo.
    echo + Containers started!
    echo Access application at: http://localhost:8080
    echo.
    echo View logs with: docker-compose logs -f
) else if "%choice%"=="3" (
    echo.
    echo Stopping: Stopping containers...
    docker-compose stop
    echo + Containers stopped
) else if "%choice%"=="4" (
    echo.
    docker-compose logs -f
) else if "%choice%"=="5" (
    echo.
    echo WARNING: This will delete all data and containers!
    set /p confirm="Are you sure? (yes/no): "
    if "%confirm%"=="yes" (
        echo Removing: Removing containers and volumes...
        docker-compose down -v
        echo + Everything cleaned up
    ) else (
        echo Cancelled
    )
) else (
    echo Invalid choice
    exit /b 1
)
