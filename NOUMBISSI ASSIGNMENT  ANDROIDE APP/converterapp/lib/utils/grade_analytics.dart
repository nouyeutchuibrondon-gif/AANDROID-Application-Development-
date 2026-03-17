import 'package:flutter/material.dart';
import '../models/student.dart';

class GradeAnalytics {
  final List<Student> students;
  
  late final double averageScore;
  late final double maxScore;
  late final double minScore;
  late final double standardDeviation;
  late final Map<String, int> gradeDistribution;
  late final Map<String, double> qualityDistribution;

  GradeAnalytics(this.students) {
    _calculateMetrics();
  }

  void _calculateMetrics() {
    if (students.isEmpty) {
      averageScore = 0;
      maxScore = 0;
      minScore = 0;
      standardDeviation = 0;
      gradeDistribution = {};
      qualityDistribution = {};
      return;
    }

    // Calculate basic stats
    final scores = students.map((s) => s.total).toList();
    averageScore = scores.fold(0.0, (a, b) => a + b) / scores.length;
    maxScore = scores.fold(0.0, (a, b) => a > b ? a : b);
    minScore = scores.fold(double.infinity, (a, b) => a < b ? a : b);

    // Calculate standard deviation
    final variance = scores
        .map((score) => (score - averageScore) * (score - averageScore))
        .fold(0.0, (a, b) => a + b) /
        scores.length;
    standardDeviation = variance > 0 ? double.parse(variance.toStringAsFixed(2)) : 0;

    // Grade distribution
    gradeDistribution = {};
    for (var student in students) {
      gradeDistribution[student.grade] = (gradeDistribution[student.grade] ?? 0) + 1;
    }

    // Quality distribution
    qualityDistribution = _calculateQualityDistribution();
  }

  Map<String, double> _calculateQualityDistribution() {
    final distribution = {
      'Excellent': 0.0,
      'Very Good': 0.0,
      'Good': 0.0,
      'Average': 0.0,
      'Poor': 0.0,
    };

    for (var student in students) {
      final quality = _getQualityCategory(student.total);
      distribution[quality] = (distribution[quality] ?? 0) + 1;
    }

    // Convert to percentages
    distribution.updateAll((key, value) {
      return (value / students.length) * 100;
    });

    return distribution;
  }

  String _getQualityCategory(double score) {
    if (score >= 90) return 'Excellent';
    if (score >= 80) return 'Very Good';
    if (score >= 70) return 'Good';
    if (score >= 60) return 'Average';
    return 'Poor';
  }

  String getQualitySummary() {
    if (students.isEmpty) return 'No data';
    
    final excellent = qualityDistribution['Excellent'] ?? 0;
    final veryGood = qualityDistribution['Very Good'] ?? 0;
    final good = qualityDistribution['Good'] ?? 0;

    if (excellent > 50) return '⭐ Outstanding Performance';
    if (excellent + veryGood > 70) return '✨ Excellent Overall';
    if (excellent + veryGood + good > 80) return '👍 Good Performance';
    return '📈 Needs Improvement';
  }

  Color getQualityColor() {
    final summary = getQualitySummary();
    if (summary.contains('Outstanding')) return const Color(0xFF10B981);
    if (summary.contains('Excellent')) return const Color(0xFF3B82F6);
    if (summary.contains('Good')) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }
}
