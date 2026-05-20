# DISHA Career Discovery Module

This branch contains only the Career Discovery feature for a plain Tomcat 9 and MySQL workflow. Deployment infrastructure should be handled after all independent modules are integrated into the main branch.

## MVC Structure

```text
src/
  dao/        JDBC database access
  model/      Career Discovery data objects
  service/    Recommendation and ranking logic
  servlet/    CareerServlet controller
  utils/      Database connection helper

WebContent/
  CSS/        Shared styling used by the module JSPs
  jsp/
    auth/     Local-only test login placeholder
    career/   Career Discovery views
    error/    Error views
  WEB-INF/
    web.xml   Servlet mapping for /career

database/
  setup.sql                         Local database/user setup
  schema.sql                        Local base schema for smoke testing
  career_discovery_module.sql       Career module tables and seed careers
  local_career_sample_student.sql   Local test student and aptitude profile
  integration_career_migration.sql  Safer migration script for shared integration DB review
```

## Manual Prerequisites

- JDK 11 or newer
- Apache Tomcat 9
- MySQL Server

Tomcat 9 is required because this module uses `javax.servlet.*`. Tomcat 10 uses `jakarta.servlet.*`.

## Manual Database Setup

Run these SQL files in MySQL in order for local testing:

```text
database/setup.sql
database/schema.sql
database/career_discovery_module.sql
database/local_career_sample_student.sql
```

If you are integrating into a shared database that already has the base `users` table, do not run the local `schema.sql` blindly. Review and run `database/integration_career_migration.sql` instead.

## Automated Build

Set `TOMCAT_HOME` for your Tomcat 9 folder:

```powershell
$env:TOMCAT_HOME = "C:\apache-tomcat-9.0.88"
```

Then build:

```powershell
.\build-local.bat
```

The script compiles Java source into `WebContent\WEB-INF\classes` and copies the MySQL driver into `WebContent\WEB-INF\lib`.

## Automated Deploy

```powershell
.\deploy-local.bat
```

By default this deploys to:

```text
%TOMCAT_HOME%\webapps\Disha
```

## Manual Smoke Test

Start Tomcat, then open:

```text
http://localhost:8080/Disha/jsp/auth/dev-student-login.jsp
```

That local-only page creates a student session and redirects to:

```text
http://localhost:8080/Disha/career
```

The production/integrated login module is expected to set a student session with `role=STUDENT` and a valid `studentId`.

Default local JDBC values are:

```text
DB_HOST=localhost
DB_PORT=3306
DB_NAME=disha_career_portal
DB_USER=disha
DB_PASSWORD=disha123
```
