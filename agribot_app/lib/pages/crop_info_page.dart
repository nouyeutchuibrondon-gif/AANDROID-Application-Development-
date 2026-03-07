import 'package:flutter/material.dart';

class CropInfoPage extends StatelessWidget {
  const CropInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('CROP INFORMATION'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentCropCard(),
            const SizedBox(height: 24),
            _buildCropStats(),
            const SizedBox(height: 24),
            _buildGrowthTimeline(),
            const SizedBox(height: 24),
            _buildRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentCropCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.greenAccent[400]!, Colors.greenAccent[700]!],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Crop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Wheat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoBox('Field Area', '25 hectares'),
              _buildInfoBox('Planted', '45 days ago'),
              _buildInfoBox('Growth Stage', 'Tillering'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCropStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Crop Statistics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildStatRow('Average Height', '15.2 cm', Colors.green),
        _buildStatRow('Stem Count', '450 per m²', Colors.blue),
        _buildStatRow('Leaf Area Index', '2.3', Colors.orange),
        _buildStatRow('Chlorophyll Content', '45.8 SPAD', Colors.deepOrange),
        _buildStatRow('Disease Incidence', '2.5%', Colors.red),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
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
          Row(
            children: [
              Container(
                width: 4,
                height: 30,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Growth Timeline',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildTimelineItem('Germination', 'Completed', true),
        _buildTimelineItem('Early Growth', 'Completed', true),
        _buildTimelineItem('Tillering', 'In Progress', false),
        _buildTimelineItem('Stem Elongation', 'Upcoming', false),
        _buildTimelineItem('Flowering', 'Upcoming', false),
        _buildTimelineItem('Grain Filling', 'Upcoming', false),
        _buildTimelineItem('Maturity', 'Upcoming', false),
      ],
    );
  }

  Widget _buildTimelineItem(String stage, String status, bool completed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: completed ? Colors.greenAccent[400]! : Colors.grey[700]!,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: completed ? Colors.greenAccent[400] : Colors.grey[700],
            ),
            child: completed
                ? const Icon(Icons.check, color: Colors.black, size: 14)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              stage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: completed
                  ? Colors.greenAccent[400]?.withOpacity(0.2)
                  : Colors.grey[800],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: completed ? Colors.greenAccent[400] : Colors.grey[400],
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Recommendations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildRecommendationItem(
          'Increase Irrigation',
          'Soil moisture is slightly low for optimal growth',
          Icons.water_drop,
          Colors.blue,
        ),
        _buildRecommendationItem(
          'Monitor Pests',
          'Weather conditions favor pest activity',
          Icons.bug_report,
          Colors.orange,
        ),
        _buildRecommendationItem(
          'Nutrient Check',
          'Plan nitrogen fertilization for next week',
          Icons.eco,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildRecommendationItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
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
