# Student Grade Converter App

## How to Open in Android Studio
1. Open Android Studio
2. File > Open > select the `StudentGradesFixed` folder
3. Wait for Gradle sync to finish (may take 2-3 minutes first time)
4. Connect phone or start emulator
5. Press the green Run button ▶

## If Gradle Sync Fails
- File > Invalidate Caches > Invalidate and Restart
- Check you have internet connection (it downloads dependencies)
- Make sure Android Studio is updated

## How to Use the App
1. Tap **"Pick Excel File"**
2. Select your .xlsx file (must have Names in column A, Marks in column B, with a header row)
3. Grades appear on screen
4. Tap **"Export Graded Excel"** to save output to Downloads folder

## Excel Format Expected
| Student Name | Marks |
|---|---|
| Alice        | 85    |
| Bob          | 72    |

## Grade Scale
- A+ = 90–100 (Excellent)
- A  = 80–89  (Very Good)
- B  = 70–79  (Good)
- C  = 60–69  (Average)
- D  = 50–59  (Pass)
- F  = 0–49   (Fail)
