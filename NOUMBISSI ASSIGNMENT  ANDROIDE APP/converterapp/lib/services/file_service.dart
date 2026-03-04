import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../models/student.dart';

class FileService {
  /// ==============================
  /// READ CSV FILE
  /// ==============================
  static Future<List<Student>> readCSV(File file) async {
    debugPrint("DEBUG: Reading CSV file...");

    try {
      final input = file.readAsStringSync();
      final fields = const CsvToListConverter().convert(input);

      List<Student> students = [];

      for (int i = 1; i < fields.length; i++) {
        final row = fields[i];

        if (row.isEmpty || row.length < 3) continue;

        String name = row[0]?.toString().trim() ?? "";
        if (name.isEmpty) continue;

        String caStr = row[1]?.toString().trim() ?? "0";
        String examStr = row[2]?.toString().trim() ?? "0";

        double ca = double.tryParse(caStr) ?? 0.0;
        double exam = double.tryParse(examStr) ?? 0.0;

        students.add(Student(name: name, ca: ca, exam: exam));
      }

      debugPrint("DEBUG: CSV Loaded -> ${students.length} students");

      return students;
    } catch (e) {
      debugPrint("ERROR: Failed to read CSV file -> $e");
      throw Exception("Error reading CSV file: $e");
    }
  }

  /// ==============================
  /// READ EXCEL FILE
  /// ==============================
  static Future<List<Student>> readExcel(File file) async {
    debugPrint("DEBUG: Reading Excel file...");

    try {
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      List<Student> students = [];

      for (var table in excel.tables.keys) {
        var tableData = excel.tables[table];
        if (tableData == null) continue;
        
        // Skip empty tables - only process tables with actual data
        if (tableData.rows.isEmpty || tableData.rows.length < 2) {
          debugPrint("DEBUG: Skipping empty table: $table");
          continue;
        }

        for (int i = 1; i < tableData.rows.length; i++) {
          var row = tableData.rows[i];
          
          // Check if row is too short
          if (row.isEmpty || row.length < 3) continue;

          try {
            // Safely extract cell values
            var nameCell = row.isNotEmpty ? row[0] : null;
            var caCell = row.length > 1 ? row[1] : null;
            var examCell = row.length > 2 ? row[2] : null;

            String name = nameCell?.value?.toString().trim() ?? "";
            if (name.isEmpty) continue;

            String caStr = caCell?.value?.toString().trim() ?? "0";
            String examStr = examCell?.value?.toString().trim() ?? "0";

            double ca = double.tryParse(caStr) ?? 0.0;
            double exam = double.tryParse(examStr) ?? 0.0;

            students.add(Student(name: name, ca: ca, exam: exam));
          } catch (rowError) {
            debugPrint("DEBUG: Skipping row $i due to error: $rowError");
            continue;
          }
        }
      }

      debugPrint("DEBUG: Excel Loaded -> ${students.length} students");

      return students;
    } catch (e) {
      debugPrint("ERROR: Failed to read Excel file -> $e");
      throw Exception("Error reading Excel file: $e");
    }
  }

  /// ==============================
  /// DETECT FILE TYPE
  /// ==============================
  static Future<List<Student>> readFile(File file) async {
    if (file.path.endsWith(".csv")) {
      return await readCSV(file);
    } else if (file.path.endsWith(".xlsx")) {
      return await readExcel(file);
    } else {
      throw Exception("Unsupported file type");
    }
  }

  /// ==============================
  /// READ CSV FILE FROM BYTES (WEB)
  /// ==============================
  static Future<List<Student>> readCSVFromBytes(Uint8List bytes) async {
    debugPrint("DEBUG: Reading CSV from bytes...");

    try {
      final input = utf8.decode(bytes, allowMalformed: true);
      final fields = const CsvToListConverter().convert(input);

      List<Student> students = [];

      for (int i = 1; i < fields.length; i++) {
        final row = fields[i];

        if (row.isEmpty || row.length < 3) continue;

        // Safely extract and validate each field
        String name = row[0]?.toString().trim() ?? "";
        if (name.isEmpty) continue;

        String caStr = row[1]?.toString().trim() ?? "0";
        String examStr = row[2]?.toString().trim() ?? "0";

        double ca = double.tryParse(caStr) ?? 0.0;
        double exam = double.tryParse(examStr) ?? 0.0;

        students.add(Student(name: name, ca: ca, exam: exam));
      }

      debugPrint("DEBUG: CSV Loaded from bytes -> ${students.length} students");

      return students;
    } catch (e) {
      debugPrint("ERROR: Failed to read CSV from bytes -> $e");
      throw Exception("Error reading CSV file: $e");
    }
  }

  /// ==============================
  /// READ EXCEL FILE FROM BYTES (WEB)
  /// ==============================
  static Future<List<Student>> readExcelFromBytes(Uint8List bytes) async {
    debugPrint("DEBUG: Reading Excel from bytes...");

    try {
      var excel = Excel.decodeBytes(bytes);

      List<Student> students = [];

      for (var table in excel.tables.keys) {
        var tableData = excel.tables[table];
        if (tableData == null) continue;
        
        // Skip empty tables - only process tables with actual data
        if (tableData.rows.isEmpty || tableData.rows.length < 2) {
          debugPrint("DEBUG: Skipping empty table: $table");
          continue;
        }

        for (int i = 1; i < tableData.rows.length; i++) {
          var row = tableData.rows[i];
          
          // Check if row is too short
          if (row.isEmpty || row.length < 3) continue;

          try {
            // Safely extract cell values
            var nameCell = row.isNotEmpty ? row[0] : null;
            var caCell = row.length > 1 ? row[1] : null;
            var examCell = row.length > 2 ? row[2] : null;

            String name = nameCell?.value?.toString().trim() ?? "";
            if (name.isEmpty) continue;

            String caStr = caCell?.value?.toString().trim() ?? "0";
            String examStr = examCell?.value?.toString().trim() ?? "0";

            double ca = double.tryParse(caStr) ?? 0.0;
            double exam = double.tryParse(examStr) ?? 0.0;

            students.add(Student(name: name, ca: ca, exam: exam));
          } catch (rowError) {
            debugPrint("DEBUG: Skipping row $i due to error: $rowError");
            continue;
          }
        }
      }

      debugPrint("DEBUG: Excel Loaded from bytes -> ${students.length} students");

      return students;
    } catch (e) {
      debugPrint("ERROR: Failed to read Excel from bytes -> $e");
      throw Exception("Error reading Excel file: $e");
    }
  }

  /// ==============================
  /// READ FILE FROM BYTES (WEB)
  /// ==============================
  static Future<List<Student>> readFileFromBytes(
      Uint8List bytes, String fileName) async {
    if (fileName.endsWith(".csv")) {
      return await readCSVFromBytes(bytes);
    } else if (fileName.endsWith(".xlsx")) {
      return await readExcelFromBytes(bytes);
    } else {
      throw Exception("Unsupported file type");
    }
  }

  /// ==============================
  /// ASSIGN GRADES
  /// ==============================
  static void assignGrades(
    List<Student> students,
    List<dynamic> grades,
    int base,
  ) {
    debugPrint("DEBUG: Assigning grades...");

    for (var student in students) {
      double scaledScore = student.total;

      for (var grade in grades) {
        // Safely access grade properties
        if (grade == null) continue;
        
        int? minValue = grade.min as int?;
        int? maxValue = grade.max as int?;
        String? gradeStr = grade.grade as String?;
        
        if (minValue == null || maxValue == null || gradeStr == null) {
          continue;
        }

        if (scaledScore >= minValue && scaledScore <= maxValue) {
          student.grade = gradeStr;
          break;
        }
      }
    }

    debugPrint("DEBUG: Grade assignment complete");
  }

  /// ==============================
  /// EXPORT NEW EXCEL FILE
  /// ==============================
  static Future<String> exportToExcel(List<Student> students) async {
    debugPrint("DEBUG: Exporting new Excel file...");

    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    sheet.appendRow(["Name", "CA (30)", "Exam (70)", "Total (100)", "Grade"]);

    for (var student in students) {
      sheet.appendRow([
        student.name,
        student.ca,
        student.exam,
        student.total,
        student.grade.isEmpty ? "-" : student.grade
      ]);
    }

    if (kIsWeb) {
      // Web: Return a message indicating file is ready for download
      debugPrint("DEBUG: File prepared for web download - graded_students.xlsx");
      return "graded_students.xlsx";
    } else {
      // Desktop/Mobile: Save to file system
      Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception("External storage directory not available");
      }
      String path = "${directory.path}/graded_students.xlsx";

      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excel.encode()!);

      debugPrint("DEBUG: File exported to $path");

      return path;
    }
  }
}
