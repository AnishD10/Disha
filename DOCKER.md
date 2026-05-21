# Docker Setup

This project now builds two independent local images:

- `disha-app:local`: Tomcat 9 with the compiled DISHA JSP/Servlet application.
- `disha-mysql:local`: MySQL 8.0 with `database/schema.sql` and `database/init.sql` loaded on first start.

## Build The Images

```powershell
docker compose build
```

## Run The System

```powershell
docker compose up -d
```

Open:

```text
http://localhost:8081/Disha/
```

Compose maps host port `8081` to Tomcat port `8080`. If your `.env` contains a different `APP_PORT`, Compose will use that host port instead.

## Test After Building

Check containers:

```powershell
docker compose ps
```

Check the app HTTP response:

```powershell
Invoke-WebRequest -UseBasicParsing http://localhost:8081/Disha/
```

Run the existing smoke test against Docker:

```powershell
.\smoke-test-local.ps1 -BaseUrl "http://localhost:8081/Disha"
```

View logs if something fails:

```powershell
docker compose logs -f app
docker compose logs -f db
```

## Run Images Manually

Use this when you want to prove the images are runnable without Compose.

```powershell
docker network create disha-net

docker run -d --name disha-manual-db --network disha-net `
  -e MYSQL_DATABASE=disha_career_portal `
  -e MYSQL_USER=disha `
  -e MYSQL_PASSWORD=disha123 `
  -e MYSQL_ROOT_PASSWORD=root123 `
  -p 3307:3306 `
  disha-mysql:local

docker run -d --name disha-manual-app --network disha-net `
  -e DB_HOST=disha-manual-db `
  -e DB_PORT=3306 `
  -e DB_NAME=disha_career_portal `
  -e DB_USER=disha `
  -e DB_PASSWORD=disha123 `
  -e DISHA_DB_HOST=disha-manual-db `
  -e DISHA_DB_PORT=3306 `
  -e DISHA_DB_NAME=disha_career_portal `
  -e DISHA_DB_USER=disha `
  -e DISHA_DB_PASSWORD=disha123 `
  -p 8081:8080 `
  disha-app:local
```

Then open:

```text
http://localhost:8081/Disha/
```

## Stop And Reset

Stop containers but keep the database volume:

```powershell
docker compose down
```

Reset the database and reload seed data on next start:

```powershell
docker compose down -v
```

If Compose reports orphan containers from an older run, clean only this Compose project with:

```powershell
docker compose down --remove-orphans
```
