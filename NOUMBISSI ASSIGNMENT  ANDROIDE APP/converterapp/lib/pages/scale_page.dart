import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'analytics_preview_page.dart';
import 'manual_input_page.dart';
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
  bool _showPreview = false;
  List<Student>? _previewStudents;
  bool _isLoading = false;

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

  Future<void> _previewAnalytics() async {
    debugPrint("DEBUG: Loading preview analytics...");

    _validateGradeScale();

    try {
      setState(() => _isLoading = true);

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

      setState(() {
        _previewStudents = students;
        _showPreview = true;
      });

      _navigateToAnalytics(students);
    } catch (e) {
      debugPrint("ERROR: Failed to load analytics -> $e");
      if (mounted) {
        _showError("Error: $e");
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToAnalytics(List<Student> students) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnalyticsPreviewPage(students: students),
      ),
    ).then((result) {
      if (result == true && mounted && _previewStudents != null) {
        _navigateToManualInput(_previewStudents!);
      }
    });
  }

  void _navigateToManualInput(List<Student> students) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ManualInputPage(
          students: students,
          grades: _grades,
          base: _selectedBase,
        ),
      ),
    ).then((result) {
      if (result != null && mounted) {
        final updatedStudents = result as List<Student>;
        _navigateToStatistics(updatedStudents);
      }
    });
  }

  void _navigateToStatistics(List<Student> students) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => StatisticsPage(students: students),
      ),
      (route) => false,
    );
  }

  void _validateGradeScale() {
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
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
      ),
    );
  }

  Widget _buildGradeRow(int index) {
    final row = _grades[index];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: row.grade,
                decoration: const InputDecoration(
                  labelText: "Grade",
                  prefixIcon: Icon(Icons.grade),
                ),
                onChanged: (value) {
                  row.grade = value;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                initialValue: row.min.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Min", prefixIcon: Icon(Icons.arrow_upward)),
                onChanged: (value) {
                  row.min = int.tryParse(value) ?? 0;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                initialValue: row.max.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Max", prefixIcon: Icon(Icons.arrow_downward)),
                onChanged: (value) {
                  row.max = int.tryParse(value) ?? 0;
                },
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
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
        title: const Text("Grade Scale Configuration"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Info Card
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDDD6FE)),
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Define Your Grade Scale",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Set the score ranges for each grade. Students will be graded based on these ranges.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Base Selection
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Grading Base:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<int>(
                      value: _selectedBase,
                      style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold),
                      items: const [
                        DropdownMenuItem(value: 100, child: Text("Out of 100")),
                        DropdownMenuItem(value: 20, child: Text("Out of 20")),
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
              ),

              const SizedBox(height: 24),

              /// Grade rows header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Grade Ranges",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addGradeRow,
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text("Add"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Grade rows list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _grades.length,
                itemBuilder: (context, index) {
                  return _buildGradeRow(index);
                },
              ),

              const SizedBox(height: 24),

              /// Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Back"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _previewAnalytics,
                      icon: _isLoading ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ) : const Icon(Icons.show_chart),
                      label: Text(_isLoading ? "Loading..." : "Preview Analytics"),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
