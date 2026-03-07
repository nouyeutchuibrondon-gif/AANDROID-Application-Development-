import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedReport = 'daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('REPORTS'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report downloaded')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportTypeSelector(),
            const SizedBox(height: 20),
            _buildReportContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildReportTab('Daily', 'daily'),
          _buildReportTab('Weekly', 'weekly'),
          _buildReportTab('Monthly', 'monthly'),
          _buildReportTab('Seasonal', 'seasonal'),
        ],
      ),
    );
  }

  Widget _buildReportTab(String label, String value) {
    final isSelected = _selectedReport == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedReport = value),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.greenAccent[400] : Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildReportContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReportHeader(),
        const SizedBox(height: 20),
        _buildReportSummary(),
        const SizedBox(height: 20),
        _buildOperationDetails(),
        const SizedBox(height: 20),
        _buildPerformanceMetrics(),
        const SizedBox(height: 20),
        _buildIssuesAndAlerts(),
      ],
    );
  }

  Widget _buildReportHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.greenAccent[400]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_selectedReport.toUpperCase()} REPORT',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generated on Mar 6, 2026',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.greenAccent[400], size: 16),
              const SizedBox(width: 8),
              Text(
                'All systems operational',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Summary',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Hours',
                '12.5',
                Icons.schedule,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Area Covered',
                '15.2 ha',
                Icons.map,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Chemical Used',
                '120 L',
                Icons.water_drop,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Operation Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Start Time', '06:00 AM'),
        _buildDetailRow('End Time', '06:30 PM'),
        _buildDetailRow('Idle Time', '1h 45m'),
        _buildDetailRow('Downtime', '15 minutes'),
        _buildDetailRow('GPS Accuracy', '±0.5 meters'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance Metrics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildMetricBar('Efficiency', 92, Colors.greenAccent),
        _buildMetricBar('Coverage', 88, Colors.blue),
        _buildMetricBar('Fuel Efficiency', 85, Colors.orange),
        _buildMetricBar('Schedule Adherence', 95, Colors.green),
      ],
    );
  }

  Widget _buildMetricBar(String label, int percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 11,
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 6,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssuesAndAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Issues & Alerts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildAlertItem(
          'Low Battery Warning',
          'Battery level dropped to 15%',
          Icons.battery_alert,
          Colors.red,
        ),
        _buildAlertItem(
          'Maintenance Due',
          'Oil change required after 480 hours',
          Icons.warning,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildAlertItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
