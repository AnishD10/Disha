@echo off
setlocal

call "%~dp0load-local-env.bat"

if "%TOMCAT_HOME%"=="" (
    echo TOMCAT_HOME is not set. Edit .env or set it in this terminal.
    exit /b 1
)

call "%TOMCAT_HOME%\bin\shutdown.bat"
