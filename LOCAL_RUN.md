# Local Run Guide

This branch is set up to run the career recommendation module locally with Tomcat 9 and MySQL. Docker is not required for this workflow.

## 1. Manual: Install Local Tools

Install or confirm:

- JDK 11 or newer
- Apache Tomcat 9
- MySQL Server

Check Java from PowerShell:

```powershell
java -version
javac -version
```

Use Tomcat 9 because the servlet code imports `javax.servlet.*`. Tomcat 10 uses `jakarta.servlet.*` and would require code changes.

## 2. Manual: Set Tomcat Path

Set `TOMCAT_HOME` in PowerShell for the current terminal:

```powershell
$env:TOMCAT_HOME = "C:\apache-tomcat-9.0.88"
```

Or in Command Prompt:

```bat
set TOMCAT_HOME=C:\apache-tomcat-9.0.88
```

Replace the path with your actual Tomcat 9 folder.

## 3. Manual: Prepare MySQL Database

The current Java defaults are in `src/main/java/DBUtil.java`:

```text
DB_HOST=localhost
DB_PORT=3306
DB_NAME=disha_career_portal
DB_USER=root
DB_PASSWORD=its2026
```

Either create a local MySQL database/user matching those values, or edit `DBUtil.java` later to match your local settings.

For a clean empty local database, run the SQL files in this order:

```text
database/setup.sql
database/schema.sql
database/career_discovery_module.sql
database/local_career_sample_student.sql
```

If your local database already has the base tables such as `users`, `user_sessions`, `assessments`, and related tables, skip `database/schema.sql` and run only:

```text
database/career_discovery_module.sql
database/local_career_sample_student.sql
```

Important: `career_discovery_module.sql` drops and recreates the career module tables. Use it only on your local isolated database, not on a shared integration database.

## 4. Automated: Build

From the project root:

```bat
build-local.bat
```

This compiles Java source into:

```text
WebContent/WEB-INF/classes
```

It also copies the MySQL driver into:

```text
WebContent/WEB-INF/lib
```

## 5. Automated: Deploy

From the project root:

```bat
deploy-local.bat
```

By default this deploys to:

```text
%TOMCAT_HOME%\webapps\Disha
```

To use a different app name:

```bat
set APP_NAME=YourAppName
deploy-local.bat
```

## 6. Manual: Start Tomcat

Start Tomcat:

```bat
%TOMCAT_HOME%\bin\startup.bat
```

Then open:

```text
http://localhost:8080/Disha/career
```

## 7. Manual: Session Requirement

`/career` requires a student session with:

```text
role=STUDENT
studentId=2
```

If the shared login module is not working yet, add a temporary local-only test login page or servlet that sets those session attributes and redirects to `/career`. Remove that helper before final integration.
