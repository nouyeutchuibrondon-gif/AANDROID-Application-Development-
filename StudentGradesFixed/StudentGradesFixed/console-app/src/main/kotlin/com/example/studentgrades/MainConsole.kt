package com.example.studentgrades

import org.apache.poi.ss.usermodel.CellType
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

data class StudentRecord(val name: String, val marks: Int, val grade: String)

fun main(args: Array<String>) {
    if (args.isEmpty()) {
        println("Usage: java -jar console-app.jar <input_excel_file>")
        return
    }

    val inputFilePath = args[0]
    val inputFile = File(inputFilePath)

    if (!inputFile.exists()) {
        println("Error: File not found at $inputFilePath")
        return
    }

    try {
        println("Loading file: ${inputFile.absolutePath}...")
        val records = loadExcelFile(inputFile)

        if (records.isEmpty()) {
            println("No data found. Ensure column A = Names, column B = Marks.")
            return
        }

        displayResults(records)
        
        val outputFileName = "StudentGrades_Output.xlsx"
        exportGradedExcel(records, outputFileName)

        println("Success! Exported to: ${File(outputFileName).absolutePath}")

    } catch (e: Exception) {
        println("An error occurred: ${e.message}")
        e.printStackTrace()
    }
}

fun loadExcelFile(file: File): List<StudentRecord> {
    val records = mutableListOf<StudentRecord>()
    FileInputStream(file).use { inputStream ->
        val workbook = XSSFWorkbook(inputStream)
        val sheet = workbook.getSheetAt(0)
        
        var firstRow = true
        for (row in sheet) {
            if (firstRow) { firstRow = false; continue }
            
            val nameCell = row.getCell(0) ?: continue
            val marksCell = row.getCell(1) ?: continue

            val name = when (nameCell.cellType) {
                CellType.STRING -> nameCell.stringCellValue.trim()
                CellType.NUMERIC -> nameCell.numericCellValue.toInt().toString()
                else -> continue
            }
            
            val marks = when (marksCell.cellType) {
                CellType.NUMERIC -> marksCell.numericCellValue.toInt()
                CellType.STRING -> marksCell.stringCellValue.trim().toIntOrNull() ?: continue
                else -> continue
            }
            
            if (name.isBlank()) continue
            records.add(StudentRecord(name, marks, calculateGrade(marks)))
        }
        workbook.close()
    }
    return records
}

fun displayResults(records: List<StudentRecord>) {
    println("\n%-20s %5s  %-16s".format("NAME", "MARKS", "GRADE"))
    println("-".repeat(46))
    for (r in records) {
        println("%-20s %5d  %-16s".format(r.name.take(20), r.marks, r.grade))
    }
    println("-".repeat(46))
    println("\nGrade Scale:")
    println("A+ = 90-100   A = 80-89   B = 70-79")
    println("C  = 60-69    D = 50-59   F = below 50\n")
}

fun exportGradedExcel(records: List<StudentRecord>, outputFileName: String) {
    val workbook = XSSFWorkbook()
    val sheet = workbook.createSheet("Grades")
    val headerRow = sheet.createRow(0)
    headerRow.createCell(0).setCellValue("Student Name")
    headerRow.createCell(1).setCellValue("Marks")
    headerRow.createCell(2).setCellValue("Grade")
    
    records.forEachIndexed { i, r ->
        val row = sheet.createRow(i + 1)
        row.createCell(0).setCellValue(r.name)
        row.createCell(1).setCellValue(r.marks.toDouble())
        row.createCell(2).setCellValue(r.grade)
    }
    
    for (i in 0..2) sheet.autoSizeColumn(i)
    
    FileOutputStream(outputFileName).use { workbook.write(it) }
    workbook.close()
}

fun calculateGrade(marks: Int): String = when {
    marks >= 90 -> "A+ (Excellent)"
    marks >= 80 -> "A  (Very Good)"
    marks >= 70 -> "B  (Good)"
    marks >= 60 -> "C  (Average)"
    marks >= 50 -> "D  (Pass)"
    else        -> "F  (Fail)"
}
