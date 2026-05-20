#!/bin/bash
# Quick setup script for Disha project

echo "================================"
echo "Disha Nepal Career Intelligence"
echo "Docker Setup Script"
echo "================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "❌ Docker is not installed!"
    echo "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo "✅ Docker is installed"

# Check if Docker daemon is running
if ! docker info > /dev/null 2>&1
then
    echo "❌ Docker daemon is not running!"
    echo "Please start Docker Desktop and try again"
    exit 1
fi

echo "✅ Docker daemon is running"
echo ""

# Ask user what to do
echo "What would you like to do?"
echo "1. Start containers (fresh build)"
echo "2. Start containers (quick start)"
echo "3. Stop containers"
echo "4. View logs"
echo "5. Reset everything (delete data)"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        echo ""
        echo "🚀 Building and starting containers..."
        docker compose up --build
        ;;
    2)
        echo ""
        echo "🚀 Starting containers..."
        docker compose up -d
        echo ""
        echo "✅ Containers started!"
        echo "🌐 Access application at: http://localhost:8080"
        echo ""
        echo "View logs with: docker compose logs -f"
        ;;
    3)
        echo ""
        echo "⏹️  Stopping containers..."
        docker compose stop
        echo "✅ Containers stopped"
        ;;
    4)
        echo ""
        docker compose logs -f
        ;;
    5)
        echo ""
        echo "⚠️  This will delete all data and containers!"
        read -p "Are you sure? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            echo "🗑️  Removing containers and volumes..."
            docker compose down -v
            echo "✅ Everything cleaned up"
        else
            echo "Cancelled"
        fi
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac
