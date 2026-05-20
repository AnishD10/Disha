# DISHA Development Integration Branch

This branch is the clean local integration base for the DISHA Career Intelligence Portal. It is intended for plain Tomcat 9 and MySQL development. Feature branches should merge their MVC modules into this structure.

## Structure

```text
src/
  dao/        Shared DAO helpers and module DAOs
  model/      Java data models
  service/    Business logic
  servlet/    Controllers/servlets added by feature branches
  utils/      Shared utilities such as DBUtil

WebContent/
  CSS/        Shared CSS
  JS/         Shared browser-side scripts
  jsp/        JSP views grouped by module or role
  WEB-INF/
    web.xml   Single deployment descriptor

database/
  schema.sql  Shared local schema
  init.sql    Shared local seed data

lib/
  mysql-connector-j-9.7.0.jar
```

## Local Configuration

Edit `.env` for your machine:

```text
TOMCAT_HOME=C:\apache-tomcat-9.0.117
JAVA_HOME=C:\Users\anish\.jdks\openjdk-26
APP_NAME=Disha
APP_PORT=8081

DB_HOST=localhost
DB_PORT=3306
DB_NAME=disha_career_portal
DB_USER=disha
DB_PASSWORD=disha123
```

## Build And Run

```powershell
.\verify-integration.ps1
.\build-local.bat
.\deploy-local.bat
.\start-local-tomcat.bat
```

Open:

```text
http://localhost:8081/Disha/
```

Use the `APP_PORT` and `APP_NAME` values from `.env` if yours differ.

Run the local auth/dashboard/assessment smoke test after deployment:

```powershell
.\smoke-test-local.ps1
```

## Integration Rules

- Keep one web root: `WebContent`.
- Keep one deployment descriptor: `WebContent/WEB-INF/web.xml`.
- Add servlet mappings to `WebContent/WEB-INF/web.xml` during integration.
- Do not commit generated files from `target`, `out`, `WebContent/WEB-INF/classes`, or copied libraries in `WebContent/WEB-INF/lib`.
- Keep module code in MVC layers: servlet/controller, service, DAO, model, JSP.
- Put shared schema changes in `database/schema.sql` or a reviewed migration file before running them on the shared integration database.
