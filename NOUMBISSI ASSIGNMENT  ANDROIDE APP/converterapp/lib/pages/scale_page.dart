import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'statistics_page.dart';
import '../services/file_service.dart';
import '../models/student.dart';

class ScalePage extends StatefulWidget {
  final File? file;
  final Uint8List? fileBytes;
  final String? fileName;

  const ScalePage({
    super.key,
    this.file,
    this.fileBytes,
    this.fileName,
  });

  @override
  State<ScalePage> createState() => _ScalePageState();
}

class _ScalePageState extends State<ScalePage> {
  int _selectedBase = 100;

  final List<_GradeRow> _grades = [
    _GradeRow(grade: "A", min: 70, max: 100),
    _GradeRow(grade: "B", min: 60, max: 69),
    _GradeRow(grade: "C", min: 50, max: 59),
    _GradeRow(grade: "D", min: 45, max: 49),
    _GradeRow(grade: "F", min: 0, max: 44),
  ];

  void _addGradeRow() {
    debugPrint("DEBUG: Adding new grade row");

    setState(() {
      _grades.add(_GradeRow(grade: "", min: 0, max: 0));
    });
  }

  void _removeRow(int index) {
    debugPrint("DEBUG: Removing grade row at index $index");

    setState(() {
      _grades.removeAt(index);
    });
  }

  Future<void> _continue() async {
    debugPrint("DEBUG: Validating grade scale...");

    for (var row in _grades) {
      if (row.grade.isEmpty) {
        _showError("Grade name cannot be empty");
        return;
      }
      if (row.min > row.max) {
        _showError("Min cannot be greater than Max");
        return;
      }
    }

    debugPrint("DEBUG: Grade scale validated successfully");

    try {
      debugPrint("DEBUG: Reading file...");
      
      if (widget.fileBytes == null && widget.file == null) {
        _showError("No file selected");
        return;
      }

      List<Student> students = widget.fileBytes != null
          ? await FileService.readFileFromBytes(widget.fileBytes!, widget.fileName ?? "file")
          : await FileService.readFile(widget.file!);

      if (students.isEmpty) {
        _showError("No student data found in file");
        return;
      }

      debugPrint("DEBUG: Assigning grades...");
      FileService.assignGrades(students, _grades, _selectedBase);

      if (!mounted) return;

      debugPrint("DEBUG: Navigating to Statistics Page with ${students.length} students");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StatisticsPage(students: students),
        ),
      );
    } catch (e) {
      debugPrint("ERROR: Failed to process file -> $e");
      if (mounted) {
        _showError("Error processing file: $e");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildGradeRow(int index) {
    final row = _grades[index];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            /// Grade Text
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: row.grade,
                decoration: const InputDecoration(labelText: "Grade"),
                onChanged: (value) {
                  row.grade = value;
                },
              ),
            ),

            const SizedBox(width: 10),

            /// Min
            Expanded(
              child: TextFormField(
                initialValue: row.min.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Min"),
                onChanged: (value) {
                  row.min = int.tryParse(value) ?? 0;
                },
              ),
            ),

            const SizedBox(width: 10),

            /// Max
            Expanded(
              child: TextFormField(
                initialValue: row.max.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Max"),
                onChanged: (value) {
                  row.max = int.tryParse(value) ?? 0;
                },
              ),
            ),

            const SizedBox(width: 10),

            /// Delete Button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeRow(index),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("DEBUG: ScalePage rebuilt");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Grade Scale"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Base Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Select Base: ",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: _selectedBase,
                  items: const [
                    DropdownMenuItem(value: 100, child: Text("Over 100")),
                    DropdownMenuItem(value: 20, child: Text("Over 20")),
                  ],
                  onChanged: (value) {
                    debugPrint("DEBUG: Base changed to $value");
                    setState(() {
                      _selectedBase = value!;
                    });
                  },
                )
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Define Grade Ranges",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: _grades.length,
                itemBuilder: (context, index) {
                  return _buildGradeRow(index);
                },
              ),
            ),

            const SizedBox(height: 10),

            /// Add Row
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _addGradeRow,
                icon: const Icon(Icons.add),
                label: const Text("Add Grade Row"),
              ),
            ),

            const SizedBox(height: 15),

            /// Continue Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _continue,
                child: const Text("Compute Grades"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grade Model
class _GradeRow {
  String grade;
  int min;
  int max;

  _GradeRow({
    required this.grade,
    required this.min,
    required this.max,
  });
}
