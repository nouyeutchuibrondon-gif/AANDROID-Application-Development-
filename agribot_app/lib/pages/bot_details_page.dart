import 'package:flutter/material.dart';
import 'control_page.dart';

class BotDetailsPage extends StatefulWidget {
  const BotDetailsPage({super.key});

  @override
  State<BotDetailsPage> createState() => _BotDetailsPageState();
}

class _BotDetailsPageState extends State<BotDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Bot Status'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bot Card
            _buildBotCard(),
            const SizedBox(height: 24),

            // Quick Stats
            _buildQuickStats(),
            const SizedBox(height: 24),

            // System Status
            _buildSystemStatus(),
            const SizedBox(height: 24),

            // Performance Metrics
            _buildPerformanceMetrics(),
            const SizedBox(height: 24),

            // Control Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ControlPage()),
                  );
                },
                icon: const Icon(Icons.gamepad),
                label: const Text('CONTROL BOT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[400],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AGRIBOT-04',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.greenAccent[400], size: 8),
                      const SizedBox(width: 6),
                      const Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.greenAccent[400],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.devices, color: Colors.black, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Model', 'AgriBot Pro X2'),
          _buildDetailRow('Firmware', 'v2.4.1'),
          _buildDetailRow('Last Sync', '2 minutes ago'),
          _buildDetailRow('Location', 'Farm Sector B'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
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
              child: _buildStatCard('Battery', '82%', Colors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('Signal', '98%', Colors.greenAccent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('Temp', '24°C', Colors.orange),
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
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System Status',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildStatusItem('Propulsion System', true),
        _buildStatusItem('Spray Mechanism', true),
        _buildStatusItem('Sensor Array', true),
        _buildStatusItem('Navigation', true),
        _buildStatusItem('Communication', true),
      ],
    );
  }

  Widget _buildStatusItem(String name, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        border: Border.all(
          color: isActive
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.error,
            color: isActive ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              color: isActive ? Colors.green : Colors.red,
              fontSize: 11,
              fontWeight: FontWeight.bold,
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
          'Performance Today',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildMetricRow('Coverage Area', '45.8 hectares', 0.65),
        _buildMetricRow('Operational Time', '8.5 hours', 0.85),
        _buildMetricRow('Spray Accuracy', '97.2%', 0.972),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, double progress) {
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation(Colors.greenAccent[400]),
            ),
          ),
        ],
      ),
    );
  }
}
