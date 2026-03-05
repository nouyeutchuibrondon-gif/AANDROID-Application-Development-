@echo off
REM =================================================================
REM Quick Start Guide - Console App
REM =================================================================

echo.
echo =========== STUDENT GRADES CONSOLE APP ===========
echo.
echo This tool converts Excel files with student marks to grades.
echo.
echo ========= CURRENT STATUS =========
echo.

REM Check Java
java -version 2>&1 | findstr /R "version" >nul
if %errorlevel% equ 0 (
    echo [OK] Java is installed
) else (
    echo [ERROR] Java not found - please install Java 11+
    pause
    exit /b 1
)

REM Check if JAR exists
if exist "console-app\build\libs\console-app.jar" (
    echo [OK] JAR file is built and ready
    echo.
    echo ========= USAGE =========
    echo.
    echo Method 1: Using batch script
    echo   run-console-app.bat students.xlsx
    echo.
    echo Method 2: Direct command
    echo   java -jar console-app\build\libs\console-app.jar students.xlsx
    echo.
    echo ========= EXAMPLE =========
    echo.
    if exist "students.xlsx" (
        echo Found students.xlsx. Running test...
        echo.
        java -jar "console-app\build\libs\console-app.jar" "students.xlsx"
    ) else (
        echo No students.xlsx found to test with.
        echo Create an Excel file with:
        echo   Column A: Student Names
        echo   Column B: Marks (0-100^)
    )
) else (
    echo [NOT BUILT] JAR file needs to be built first
    echo.
    echo ========= BUILD INSTRUCTIONS =========
    echo.
    echo Option 1: Using Android Studio
    echo   1. Open this folder in Android Studio
    echo   2. Terminal menu ^> New Terminal
    echo   3. gradle console-app:build -x test
    echo.
    echo Option 2: Using local Gradle
    echo   1. Download gradle-8.5-all.zip from gradle.org
    echo   2. Extract to this directory
    echo   3. gradle-8.5\bin\gradle.bat console-app:build -x test
    echo.
    echo For full instructions: see CONSOLE_APP_GUIDE.txt
    echo.
)

echo.
pause
