Add-Type -AssemblyName 'Microsoft.Office.Interop.Excel'

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false

$workbook = $excel.Workbooks.Add()
$worksheet = $workbook.ActiveSheet

# Add headers
$worksheet.Cells(1, 1) = 'Name'
$worksheet.Cells(1, 2) = 'CA'
$worksheet.Cells(1, 3) = 'Exam'

# Add sample student data
$students = @(
    @('Chioma Okafor', 25, 65),
    @('Ahmed Hassan', 28, 72),
    @('Blessing Adeyemi', 20, 58),
    @('Jennifer Smith', 30, 75),
    @('David Chen', 22, 68),
    @('Sarah Williams', 26, 71),
    @('Michael Brown', 24, 62),
    @('Grace Okonkwo', 29, 78),
    @('Kola Oluwaseun', 19, 55),
    @('Amara Nwosu', 27, 73)
)

$row = 2
foreach ($student in $students) {
    $worksheet.Cells($row, 1) = $student[0]
    $worksheet.Cells($row, 2) = $student[1]
    $worksheet.Cells($row, 3) = $student[2]
    $row++
}

# Auto-fit columns
$worksheet.Columns.Item(1).AutoFit() | Out-Null
$worksheet.Columns.Item(2).AutoFit() | Out-Null
$worksheet.Columns.Item(3).AutoFit() | Out-Null

# Save the workbook
$outputPath = 'C:\Users\BC\Downloads\converterapp\demo_students.xlsx'
$workbook.SaveAs($outputPath)

$excel.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null

Write-Host "Excel file created successfully: $outputPath"
