# PowerShell script to run Student Grades Console App
# Usage: .\run-console-app.ps1 -ExcelFile "path\to\students.xlsx"

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$ExcelFile
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Student Grades Console App" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if file exists
if (-not (Test-Path $ExcelFile)) {
    Write-Host "ERROR: File not found: $ExcelFile" -ForegroundColor Red
    exit 1
}

Write-Host "Processing file: $ExcelFile"
Write-Host ""

# Check if JAR exists
$jarPath = "console-app\build\libs\console-app.jar"
if (-not (Test-Path $jarPath)) {
    Write-Host "ERROR: JAR file not found at: $jarPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "SOLUTION: Build the project first" -ForegroundColor Yellow
    Write-Host "  1. Download Gradle 8.5 from gradle.org"
    Write-Host "  2. Extract as gradle-8.5 in this directory"
    Write-Host "  3. Run: gradle-8.5\bin\gradle.bat console-app:build -x test"
    Write-Host ""
    Write-Host "Or use Android Studio > Terminal > gradle console-app:build -x test"
    exit 1
}

# Run the application
Write-Host "Converting marks to grades..." -ForegroundColor Green
Write-Host ""

java -jar $jarPath $ExcelFile

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host "Check StudentGrades_Output.xlsx for results"
} else {
    Write-Host ""
    Write-Host "ERROR: Conversion failed" -ForegroundColor Red
    exit 1
}
