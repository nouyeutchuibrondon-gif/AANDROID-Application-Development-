import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/student.dart';
import '../services/file_service.dart';

class StatisticsPage extends StatelessWidget {
  final List<Student> students;

  const StatisticsPage({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    Map<String, int> gradeCount = {};

    for (var s in students) {
      gradeCount[s.grade] = (gradeCount[s.grade] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Statistics & Results")),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: "Chart", icon: Icon(Icons.pie_chart)),
                Tab(text: "Results", icon: Icon(Icons.table_chart)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  /// Chart Tab
                  _buildChartTab(gradeCount),

                  /// Results Tab
                  _buildResultsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _exportResults(context),
        tooltip: "Export Results",
        child: const Icon(Icons.download),
      ),
    );
  }

  Widget _buildChartTab(Map<String, int> gradeCount) {
    if (gradeCount.isEmpty) {
      return const Center(
        child: Text("No grade data available"),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: PieChart(
        PieChartData(
          sections: gradeCount.entries.map((entry) {
            return PieChartSectionData(
              value: entry.value.toDouble(),
              title: "${entry.key}\n${entry.value}",
              radius: 60,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildResultsTab() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("CA (30)"), numeric: true),
              DataColumn(label: Text("Exam (70)"), numeric: true),
              DataColumn(label: Text("Total (100)"), numeric: true),
              DataColumn(label: Text("Grade")),
            ],
            rows: students.map((student) {
              return DataRow(
                cells: [
                  DataCell(Text(student.name)),
                  DataCell(Text(student.ca.toStringAsFixed(1))),
                  DataCell(Text(student.exam.toStringAsFixed(1))),
                  DataCell(Text(student.total.toStringAsFixed(1))),
                  DataCell(
                    Container(
                      decoration: BoxDecoration(
                        color: _getGradeColor(student.grade),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        student.grade.isEmpty ? "-" : student.grade,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.deepOrange;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _exportResults(BuildContext context) async {
    try {
      String path = await FileService.exportToExcel(students);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Exported to: $path")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Export failed: $e")),
        );
      }
    }
  }
}
