package com.example.studentgrades

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.*
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.card.MaterialCardView
import org.apache.poi.ss.usermodel.CellType
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import java.io.InputStream
import java.io.OutputStream

data class StudentRecord(val name: String, val marks: Int, val grade: String)

class MainActivity : AppCompatActivity() {

    private lateinit var btnPickFile: MaterialButton
    private lateinit var btnExport: MaterialButton
    private lateinit var tvStatus: TextView
    private lateinit var tvOutput: TextView
    private lateinit var cardOutput: MaterialCardView
    private lateinit var progressBar: ProgressBar

    private var studentRecords: List<StudentRecord> = emptyList()

    private val pickFileLauncher = registerForActivityResult(ActivityResultContracts.GetContent()) { uri: Uri? ->
        uri?.let {
            tvStatus.text = "Processing file..."
            progressBar.visibility = View.VISIBLE
            loadExcelFromUri(it)
        }
    }

    private val saveFileLauncher = registerForActivityResult(ActivityResultContracts.CreateDocument("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")) { uri: Uri? ->
        uri?.let {
            exportGradedExcel(it)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        btnPickFile = findViewById(R.id.btnPickFile)
        btnExport = findViewById(R.id.btnExport)
        tvStatus = findViewById(R.id.tvStatus)
        tvOutput = findViewById(R.id.tvOutput)
        cardOutput = findViewById(R.id.cardOutput)
        progressBar = findViewById(R.id.progressBar)

        btnExport.isEnabled = false
        cardOutput.visibility = View.GONE

        btnPickFile.setOnClickListener {
            pickFileLauncher.launch("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        }

        btnExport.setOnClickListener {
            if (studentRecords.isNotEmpty()) {
                saveFileLauncher.launch("StudentGrades_Results.xlsx")
            }
        }
    }

    private fun loadExcelFromUri(uri: Uri) {
        Thread {
            try {
                val inputStream: InputStream? = contentResolver.openInputStream(uri)
                if (inputStream == null) {
                    runOnUiThread { tvStatus.text = "Error: Could not open file" }
                    return@Thread
                }

                val workbook = XSSFWorkbook(inputStream)
                val sheet = workbook.getSheetAt(0)
                
                val records = mutableListOf<StudentRecord>()
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
                inputStream.close()

                runOnUiThread {
                    if (records.isEmpty()) {
                        tvStatus.text = "No valid data found. Use Column A for Names, B for Marks."
                        cardOutput.visibility = View.GONE
                        btnExport.isEnabled = false
                    } else {
                        studentRecords = records
                        displayResults(records)
                        tvStatus.text = "Successfully loaded ${records.size} students"
                        cardOutput.visibility = View.VISIBLE
                        btnExport.isEnabled = true
                    }
                    progressBar.visibility = View.GONE
                }

            } catch (e: Exception) {
                runOnUiThread {
                    tvStatus.text = "Error reading file: ${e.localizedMessage}"
                    progressBar.visibility = View.GONE
                }
            }
        }.start()
    }

    private fun displayResults(records: List<StudentRecord>) {
        val sb = StringBuilder()
        sb.append("%-20s %-8s %-10s\n".format("NAME", "MARKS", "GRADE"))
        sb.append("-".repeat(40)).append("\n")
        for (r in records) {
            sb.append("%-20s %-8d %-10s\n".format(r.name.take(20), r.marks, r.grade))
        }
        tvOutput.text = sb.toString()
    }

    private fun exportGradedExcel(uri: Uri) {
        progressBar.visibility = View.VISIBLE
        Thread {
            try {
                val workbook = XSSFWorkbook()
                val sheet = workbook.createSheet("Grades")
                val headerRow = sheet.createRow(0)
                headerRow.createCell(0).setCellValue("Student Name")
                headerRow.createCell(1).setCellValue("Marks")
                headerRow.createCell(2).setCellValue("Grade")
                
                studentRecords.forEachIndexed { i, r ->
                    val row = sheet.createRow(i + 1)
                    row.createCell(0).setCellValue(r.name)
                    row.createCell(1).setCellValue(r.marks.toDouble())
                    row.createCell(2).setCellValue(r.grade)
                }
                for (i in 0..2) sheet.autoSizeColumn(i)

                val outputStream: OutputStream? = contentResolver.openOutputStream(uri)
                outputStream?.use { workbook.write(it) }
                workbook.close()

                runOnUiThread {
                    progressBar.visibility = View.GONE
                    Toast.makeText(this, "File saved successfully!", Toast.LENGTH_LONG).show()
                }
            } catch (e: Exception) {
                runOnUiThread {
                    progressBar.visibility = View.GONE
                    Toast.makeText(this, "Export failed: ${e.message}", Toast.LENGTH_LONG).show()
                }
            }
        }.start()
    }

    private fun calculateGrade(marks: Int): String = when {
        marks >= 90 -> "A+"
        marks >= 80 -> "A"
        marks >= 70 -> "B"
        marks >= 60 -> "C"
        marks >= 50 -> "D"
        else        -> "F"
    }
}
