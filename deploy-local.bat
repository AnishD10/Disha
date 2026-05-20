@echo off
setlocal

if "%TOMCAT_HOME%"=="" (
    echo TOMCAT_HOME is not set.
    echo Example: set TOMCAT_HOME=C:\apache-tomcat-9.0.88
    exit /b 1
)

if "%APP_NAME%"=="" set APP_NAME=Disha

if not exist "%TOMCAT_HOME%\webapps" (
    echo Tomcat webapps folder was not found at "%TOMCAT_HOME%\webapps".
    exit /b 1
)

echo Deploying WebContent to %TOMCAT_HOME%\webapps\%APP_NAME% ...
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "$dest = '%TOMCAT_HOME%\webapps\%APP_NAME%'; if (Test-Path $dest) { Remove-Item -LiteralPath $dest -Recurse -Force }; New-Item -ItemType Directory -Path $dest | Out-Null; Copy-Item -Path 'WebContent\*' -Destination $dest -Recurse -Force"
if errorlevel 1 (
    echo Deployment failed.
    exit /b 1
)

echo Deployment complete.
echo App URL: http://localhost:8080/%APP_NAME%/career
exit /b 0
