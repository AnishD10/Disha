@echo off
setlocal enabledelayedexpansion

if "%TOMCAT_HOME%"=="" (
    echo TOMCAT_HOME is not set.
    echo Example: set TOMCAT_HOME=C:\apache-tomcat-9.0.88
    exit /b 1
)

if not exist "%TOMCAT_HOME%\lib\servlet-api.jar" (
    echo servlet-api.jar was not found at "%TOMCAT_HOME%\lib\servlet-api.jar".
    echo Use Tomcat 9 and check your TOMCAT_HOME path.
    exit /b 1
)

if not exist "lib\mysql-connector-j-9.7.0.jar" (
    echo MySQL connector was not found at lib\mysql-connector-j-9.7.0.jar.
    exit /b 1
)

if not exist "WebContent\WEB-INF" mkdir "WebContent\WEB-INF"
if not exist "WebContent\WEB-INF\classes" mkdir "WebContent\WEB-INF\classes"
if not exist "WebContent\WEB-INF\lib" mkdir "WebContent\WEB-INF\lib"

if exist ".local-sources.txt" del ".local-sources.txt" >nul 2>nul
for /f "delims=" %%F in ('dir /s /b "src\*.java"') do (
    set "sourceFile=%%F"
    set "sourceFile=!sourceFile:\=/!"
    echo "!sourceFile!" >> ".local-sources.txt"
)

echo Compiling Java source into WebContent\WEB-INF\classes ...
javac -encoding UTF-8 -d "WebContent\WEB-INF\classes" -cp "%TOMCAT_HOME%\lib\servlet-api.jar;lib\mysql-connector-j-9.7.0.jar" @.local-sources.txt
if errorlevel 1 (
    echo Compilation failed.
    del ".local-sources.txt" >nul 2>nul
    exit /b 1
)

copy /Y "lib\mysql-connector-j-9.7.0.jar" "WebContent\WEB-INF\lib\" >nul
del ".local-sources.txt" >nul 2>nul

echo Build complete.
echo Classes: WebContent\WEB-INF\classes
echo MySQL driver: WebContent\WEB-INF\lib
exit /b 0
