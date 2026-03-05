@echo off
REM =================================================================
REM Student Grades Console App Runner
REM Converts student marks from Excel to letter grades
REM =================================================================

if "%~1"=="" (
    echo.
    echo USAGE: run-console-app.bat ^<path-to-excel-file^>
    echo.
    echo EXAMPLES:
    echo   run-console-app.bat students.xlsx
    echo   run-console-app.bat C:\Users\YourName\Downloads\marks.xlsx
    echo.
    echo EXCEL FILE FORMAT REQUIRED:
    echo   Column A: Student Names
    echo   Column B: Marks (0-100^)
    echo   First row: Header row (will be skipped^)
    echo.
    echo GRADE SCALE:
    echo   A+ = 90-100, A = 80-89, B = 70-79
    echo   C = 60-69, D = 50-59, F = below 50
    echo.
    echo OUTPUT:
    echo   StudentGrades_Output.xlsx (created in same directory as input^)
    echo.
    pause
    exit /b 1
)

setlocal enabledelayedexpansion
cd /d "%~dp0"

set EXCEL_FILE=%~1
set JAR_PATH=console-app\build\libs\console-app.jar

REM Check if file exists
if not exist "!EXCEL_FILE!" (
    echo.
    echo ERROR: File not found: !EXCEL_FILE!
    echo.
    echo Please provide a valid path to an Excel file.
    pause
    exit /b 1
)

REM Check if JAR already exists
if exist "!JAR_PATH!" (
    echo.
    echo Processing: !EXCEL_FILE!
    echo.
    java -jar "!JAR_PATH!" "!EXCEL_FILE!"
    if !errorlevel! equ 0 (
        echo.
        echo SUCCESS! Check StudentGrades_Output.xlsx
    )
    pause
    exit /b !errorlevel!
)

REM JAR doesn't exist - provide helpful message
echo.
echo ERROR: JAR file not found at: !JAR_PATH!
echo.
echo SOLUTION - Build the project first:
echo.
echo   Step 1: Download Gradle 8.5 from https://gradle.org/releases/
echo   Step 2: Extract to this directory as: gradle-8.5
echo   Step 3: Run build command:
echo           gradle-8.5\bin\gradle.bat console-app:build -x test
echo.
echo   OR use Android Studio:
echo   Step 1: File ^> Open ^> Select this folder
echo   Step 2: Wait for Gradle sync
echo   Step 3: Terminal ^> gradle console-app:build -x test
echo.
echo For detailed instructions, see: CONSOLE_APP_GUIDE.txt
echo.
pause
exit /b 1
