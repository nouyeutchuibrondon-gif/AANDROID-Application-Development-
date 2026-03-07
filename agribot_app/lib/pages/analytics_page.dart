import 'package:flutter/material.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _selectedMetric = 'temperature';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('ANALYTICS'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Metrics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMetricSelector(),
            const SizedBox(height: 24),
            _buildChart(),
            const SizedBox(height: 24),
            _buildStatistics(),
            const SizedBox(height: 24),
            _buildAlerts(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricSelector() {
    final metrics = [
      {'key': 'temperature', 'label': 'Temperature', 'icon': Icons.thermostat},
      {'key': 'humidity', 'label': 'Humidity', 'icon': Icons.water_drop},
      {'key': 'moisture', 'label': 'Moisture', 'icon': Icons.grain},
      {'key': 'light', 'label': 'Light', 'icon': Icons.light_mode},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: metrics.map((metric) {
          final isSelected = _selectedMetric == metric['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(metric['label'] as String),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedMetric = metric['key'] as String;
                });
              },
              backgroundColor: Colors.grey[900],
              selectedColor: Colors.greenAccent[400],
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last 24 Hours',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (index) {
                final height = 30 + (index * 8) % 100;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 20,
                      height: height.toDouble(),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[400],
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${index * 2}h',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 8,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Average', '24.5°C', Colors.orange),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('Maximum', '28.2°C', Colors.red),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('Minimum', '18.3°C', Colors.blue),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alerts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildAlertItem(
          'Low Moisture Level',
          'Soil moisture is below 40%',
          Colors.orange,
          Icons.warning,
        ),
        const SizedBox(height: 8),
        _buildAlertItem(
          'Battery Low',
          'Battery level at 20%',
          Colors.red,
          Icons.battery_alert,
        ),
      ],
    );
  }

  Widget _buildAlertItem(
    String title,
    String description,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
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
                    fontSize: 13,
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
