import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/student.dart';
import '../utils/grade_analytics.dart';

class AnalyticsPreviewPage extends StatelessWidget {
  final List<Student> students;

  const AnalyticsPreviewPage({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    final analytics = GradeAnalytics(students);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Preview'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Quality Summary Card
              _buildQualitySummaryCard(analytics),
              const SizedBox(height: 20),

              /// Key Statistics
              _buildStatsGrid(analytics),
              const SizedBox(height: 20),

              /// Quality Distribution Pie Chart
              _buildQualityChart(analytics),
              const SizedBox(height: 20),

              /// Grade Distribution Bar Chart
              _buildGradeChart(analytics),
              const SizedBox(height: 20),

              /// Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Convert to Grades'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQualitySummaryCard(GradeAnalytics analytics) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [analytics.getQualityColor(), analytics.getQualityColor().withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            analytics.getQualitySummary(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Average', '${analytics.averageScore.toStringAsFixed(1)}', Colors.white70),
              _buildStatItem('Total', '${students.length}', Colors.white70),
              _buildStatItem('Range', '${analytics.minScore.toStringAsFixed(1)}-${analytics.maxScore.toStringAsFixed(1)}', Colors.white70),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        Text(label, style: TextStyle(fontSize: 12, color: textColor)),
      ],
    );
  }

  Widget _buildStatsGrid(GradeAnalytics analytics) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatCard('Highest', '${analytics.maxScore.toStringAsFixed(1)}', const Color(0xFF10B981), Icons.trending_up),
        _buildStatCard('Lowest', '${analytics.minScore.toStringAsFixed(1)}', const Color(0xFFEF4444), Icons.trending_down),
        _buildStatCard('Average', '${analytics.averageScore.toStringAsFixed(1)}', const Color(0xFF3B82F6), Icons.equalizer),
        _buildStatCard('Std Dev', '${analytics.standardDeviation.toStringAsFixed(2)}', const Color(0xFFF59E0B), Icons.show_chart),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildQualityChart(GradeAnalytics analytics) {
    final distribution = analytics.qualityDistribution;
    final colors = {
      'Excellent': const Color(0xFF10B981),
      'Very Good': const Color(0xFF3B82F6),
      'Good': const Color(0xFFF59E0B),
      'Average': const Color(0xFFEF4444),
      'Poor': const Color(0xFF64748B),
    };

    if (distribution.values.every((v) => v == 0)) {
      return const Center(child: Text('No data'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quality Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sections: distribution.entries.map((entry) {
                return PieChartSectionData(
                  value: entry.value,
                  title: '${entry.value.toStringAsFixed(0)}%',
                  color: colors[entry.key] ?? Colors.grey,
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: colors.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: entry.value, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(entry.key, style: const TextStyle(fontSize: 12)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGradeChart(GradeAnalytics analytics) {
    final gradeData = analytics.gradeDistribution;
    final sortedGrades = gradeData.keys.toList()..sort();

    if (gradeData.isEmpty) {
      return const Center(child: Text('No grade data'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Grade Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: BarChart(
            BarChartData(
              maxY: (gradeData.values.fold(0, (a, b) => a > b ? a : b) + 1).toDouble(),
              barGroups: sortedGrades.asMap().entries.map((entry) {
                final grade = entry.value;
                final count = gradeData[grade] ?? 0;
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: count.toDouble(),
                      color: _getGradeColor(grade),
                      width: 20,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < sortedGrades.length) {
                        return Text(sortedGrades[value.toInt()]);
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return const Color(0xFF10B981);
      case 'B':
        return const Color(0xFF3B82F6);
      case 'C':
        return const Color(0xFFF59E0B);
      case 'D':
        return const Color(0xFFEF4444);
      case 'F':
        return const Color(0xFF64748B);
      default:
        return Colors.grey;
    }
  }
}
