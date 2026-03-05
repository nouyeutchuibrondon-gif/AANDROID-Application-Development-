# Student Grades Console App - Complete Setup & Usage Guide

## What Is This?

A **standalone command-line tool** that converts student marks from Excel files (.xlsx) into letter grades. No GUI, no Android required - just pure command-line processing.

**Grade Scale:**
- A+ = 90-100 (Excellent)
- A = 80-89 (Very Good)
- B = 70-79 (Good)
- C = 60-69 (Average)
- D = 50-59 (Pass)
- F = 0-49 (Fail)

---

## Prerequisites

- **Java 11 or later** (you have: Java 17 ✓)
- **Gradle 8.5** OR **Android Studio** with Gradle

### Check Java Installation

```powershell
java -version
```

If not installed, download from: https://adoptium.net/

---

## Quick Setup (4 Steps)

### Step 1: Download Gradle 8.5

Visit: https://gradle.org/releases/
Download: **gradle-8.5-all.zip** (about 330 MB)

### Step 2: Extract Gradle

Extract the ZIP file to the project root directory `StudentGradesFixed/`

After extraction, you should have:
```
StudentGradesFixed/
  ├── gradle-8.5/
  ├── console-app/
  ├── app/
  └── ... (other files)
```

### Step 3: Build the Console App

Open Command Prompt in the `StudentGradesFixed` directory:

```batch
gradle-8.5\bin\gradle.bat console-app:build -x test
```

Wait 2-3 minutes for the build to complete.

### Step 4: Test It Works

```batch
java -jar console-app\build\libs\console-app.jar students.xlsx
```

If successful, you'll see output like:
```
Loading file: C:\path\to\students.xlsx...

NAME                 MARKS  GRADE
--------------------------------------------
Alice                   85  A  (Very Good)
Bob                     72  B  (Good)
Charlie                 95  A+ (Excellent)
--------------------------------------------

Success! Exported to: StudentGrades_Output.xlsx
```

---

## Alternative Setup Methods

### Option A: Using Android Studio

If you have Android Studio installed:

1. **File** → **Open** → Select `StudentGradesFixed` folder
2. Wait for Gradle sync to complete
3. **Terminal** → **New Terminal**
4. Type: `gradle console-app:build -x test`
5. Done!

### Option B: Using IntelliJ IDEA

1. Open the project in IntelliJ IDEA
2. Gradle will auto-detect and sync
3. Run the build task for console-app

### Option C: Global Gradle Installation

If you have Gradle installed globally on your system:

```batch
cd StudentGradesFixed
gradle console-app:build -x test
```

---

## Usage

### Method 1: Batch Script (Recommended for Windows)

```batch
run-console-app.bat students.xlsx
```

Creates output file: `StudentGrades_Output.xlsx` (in same folder as input)

### Method 2: Direct Java Command

```batch
java -jar console-app\build\libs\console-app.jar students.xlsx
```

### Method 3: PowerShell Script

```powershell
.\run-console-app.ps1 -ExcelFile "students.xlsx"
```

### Method 4: From Any Directory

**Option A: Copy JAR to Program Files**

```batch
mkdir "C:\Program Files\StudentGrades\"
copy console-app\build\libs\console-app.jar "C:\Program Files\StudentGrades\"
```

Then create `grade-converter.bat`:
```batch
@echo off
java -jar "C:\Program Files\StudentGrades\console-app.jar" %1
pause
```

Now use from anywhere:
```batch
grade-converter.bat C:\Users\John\Downloads\marks.xlsx
```

---

## Excel Input Format

Your Excel file MUST have this exact format:

| Column A | Column B |
|----------|----------|
| Name | Marks |
| Alice | 85 |
| Bob | 72 |
| Charlie | 95 |

**Important:**
- Column A = Student Names
- Column B = Numerical marks (0-100)
- First row = Header (will be skipped)
- No empty rows in the middle of data
- Max file size: Depends on Java heap (typically 1000+ students is fine)

### Example Files

You can test with the included `students.xlsx` file:
```batch
run-console-app.bat students.xlsx
```

---

## Output File

The app creates: **`StudentGrades_Output.xlsx`**

Location: Same directory as the input file

Contains 3 columns:
1. **Student Name** - from input
2. **Marks** - from input  
3. **Grade** - calculated grade (A+, A, B, C, D, F)

### Example Output

| Student Name | Marks | Grade |
|---|---|---|
| Alice | 85 | A  (Very Good) |
| Bob | 72 | B  (Good) |
| Charlie | 95 | A+ (Excellent) |

---

## Troubleshooting

### "Error: Could not find or load main class"

**Problem:** JAR file doesn't exist yet

**Solution:** 
1. Download Gradle 8.5
2. Run: `gradle-8.5\bin\gradle.bat console-app:build -x test`
3. Wait for build to complete
4. Then run the app

### "No valid data found"

**Problem:** Excel file has wrong format

**Fix:**
- Column A must have Names (first row skipped)
- Column B must have Numbers (0-100)
- No empty rows between student data

**Example correct format:**
```
| Name | Marks |
| ---- | ----- |
| Alice | 85 |
| Bob | 72 |
```

### "File not found" error

**Problem:** Path to Excel file is wrong

**Solution:**
- Use full path: `C:\Users\YourName\Downloads\students.xlsx`
- Put file in same directory as batch script first
- Check file name spelling

### Build fails with "Gradle execution failed"

**Solution:**
```batch
gradle clean console-app:build -x test
```

Or if using gradle-8.5:
```batch
gradle-8.5\bin\gradle.bat clean console-app:build -x test
```

### "Java not found"

**Solution:**
1. Install Java from https://adoptium.net/
2. Check installation: `java -version`
3. Restart Command Prompt
4. Try again

---

## Advanced Usage

### Batch Processing Multiple Files

Create a batch file `process-all.bat`:
```batch
@echo off
for %%f in (*.xlsx) do (
    echo Processing %%f
    java -jar console-app\build\libs\console-app.jar "%%f"
    timeout /t 2
)
echo All files processed!
pause
```

### Custom Grade Scale

To modify the grade scale:

1. Go to: `console-app/src/main/kotlin/com/example/studentgrades/MainConsole.kt`
2. Find function: `fun calculateGrade(marks: Int): String`
3. Modify the when block:
   ```kotlin
   fun calculateGrade(marks: Int): String = when {
       marks >= 90 -> "A+ (Excellent)"
       marks >= 80 -> "A  (Very Good)"
       marks >= 70 -> "B  (Good)"
       marks >= 60 -> "C  (Average)"
       marks >= 50 -> "D  (Pass)"
       else        -> "F  (Fail)"
   }
   ```
4. Rebuild: `gradle console-app:build -x test`

---

## Project Structure

```
StudentGradesFixed/
├── console-app/              # Console app module (what we're using)
│   ├── src/main/kotlin/
│   │   └── com/example/studentgrades/
│   │       └── MainConsole.kt   # Entry point
│   └── build.gradle
├── app/                       # Android app module (separate UI)
├── gradle-8.5/               # (After you download and extract)
├── run-console-app.bat        # Batch script runner
├── run-console-app.ps1        # PowerShell runner
├── CONSOLE_APP_GUIDE.txt      # This file
└── ...
```

---

## Performance

- Processing 1,000 students: ~1-2 seconds
- Processing 10,000 students: ~5-10 seconds
- Processing 100,000+ students: Depends on system RAM

For very large files (100K+ rows), you may need to increase Java heap:
```batch
java -Xmx2048m -jar console-app\build\libs\console-app.jar large-file.xlsx
```

This allocates 2GB of RAM to Java.

---

## System Requirements

| Component | Requirement |
|-----------|-------------|
| Java | 11+ (17 LTS recommended) |
| Gradle | 8.5 |
| RAM | Min 512MB, recommended 2GB+ |
| Disk Space | 1.5GB (for Gradle + dependencies) |
| OS | Windows, Mac, or Linux |

---

## Getting Help

1. **Check existing output file is correct:** `StudentGrades_Output.xlsx`
2. **Review error message** in the console
3. **Check Excel file format** (see example above)
4. **Try with a smaller test file** first
5. **Check CONSOLE_APP_GUIDE.txt** for quick reference

---

## Additional Notes

- **No internet required** after initial setup
- **Portable:** Copy the JAR to any computer with Java
- **Fast:** Processes large files quickly
- **Safe:** Original Excel file is never modified
- **Standalone:** Can run from Command Prompt, PowerShell, or batch scripts

---

## Quick Commands Reference

```batch
# Build the app
gradle-8.5\bin\gradle.bat console-app:build -x test

# Run the app
java -jar console-app\build\libs\console-app.jar students.xlsx

# Clean and rebuild
gradle-8.5\bin\gradle.bat clean console-app:build -x test

# Test with included file
run-console-app.bat students.xlsx

# Run with higher memory
java -Xmx2048m -jar console-app\build\libs\console-app.jar input.xlsx
```

---

## Version Info

- **Project Version:** 1.0
- **Gradle Version:** 8.5
- **Kotlin Version:** 1.9.22
- **Java Target:** 11+
- **Build Date:** March 2, 2026

---

## License & Credits

Part of the StudentGradesFixed project. 

For more information, see README.md
