@echo off
REM Setup script for Student Grades Console App
REM This installs Gradle and builds the console app JAR

echo Checking prerequisites...

REM Check if Java is installed
java -version >nul 2>&1
if errorlevel 1 (
    echo Error: Java is not installed. Please install Java 11 or later.
    echo Download from: https://adoptium.net/
    exit /b 1
)

echo Java found: 
java -version

REM Check if gradle wrapper jar exists
if exist "gradle\wrapper\gradle-wrapper.jar" (
    echo Gradle wrapper jar found, trying to use it...
    call gradlew.bat --version
    if errorlevel 1 (
        echo Gradle wrapper failed, will download gradle instead
    ) else (
        echo Using gradle wrapper
        exit /b 0
    )
)

echo.
echo Downloading Gradle 8.5...
echo Please wait, this may take a few minutes...
echo.

REM Use bitsadmin to download gradle (available on Windows)
bitsadmin /transfer gradledownload /download /resume https://services.gradle.org/distributions/gradle-8.5-all.zip "%CD%\gradle-8.5-all.zip"

if not exist "gradle-8.5-all.zip" (
    echo.
    echo Error: Failed to download Gradle
    echo Manual installation required:
    echo 1. Download from: https://gradle.org/releases/
    echo 2. Extract gradle-8.5-all.zip to this directory
    echo 3. Rename the extracted folder to "gradle-8.5"
    echo 4. Run this script again
    exit /b 1
)

echo Extracting Gradle...
powershell -NoProfile -Command "Expand-Archive -Path 'gradle-8.5-all.zip' -DestinationPath '.' -Force"

if not exist "gradle-8.5" (
    echo Failed to extract Gradle
    exit /b 1
)

del gradle-8.5-all.zip
echo Gradle setup successful!

echo.
echo Building console app...
call gradle-8.5\bin\gradle.bat console-app:build -x test

if errorlevel 1 (
    echo Build failed!
    exit /b 1
)

echo.
echo Setup complete! 
echo You can now run: run-console-app.bat students.xlsx
