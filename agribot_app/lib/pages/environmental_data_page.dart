import 'package:flutter/material.dart';

class EnvironmentalDataPage extends StatefulWidget {
  const EnvironmentalDataPage({super.key});

  @override
  State<EnvironmentalDataPage> createState() => _EnvironmentalDataPageState();
}

class _EnvironmentalDataPageState extends State<EnvironmentalDataPage> {
  String _selectedPeriod = 'Week';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text('Environmental Data'),
            Text(
              'AGRIBOT Unit #042',
              style: TextStyle(
                color: Colors.greenAccent[400],
                fontSize: 11,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.greenAccent[400]),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Period Selector
            _buildPeriodSelector(),
            const SizedBox(height: 24),

            // Temperature
            _buildMetricCard(
              title: 'Temperature',
              value: '24.8°C',
              trend: '+2.4%',
              trendColor: Colors.green,
              chart: _buildTemperatureChart(),
            ),
            const SizedBox(height: 24),

            // Humidity
            _buildMetricCard(
              title: 'Humidity',
              value: '62%',
              trend: '-5.1%',
              trendColor: Colors.red,
              chart: _buildHumidityChart(),
            ),
            const SizedBox(height: 24),

            // Soil Moisture
            _buildMetricCard(
              title: 'Soil Moisture',
              value: '45.2%',
              trend: 'Optimal',
              trendColor: Colors.green,
              chart: _buildMoistureChart(),
            ),
            const SizedBox(height: 24),

            // Light Intensity
            _buildMetricCard(
              title: 'Light Intensity',
              value: '12,450 Lux',
              trend: 'Direct',
              trendColor: Colors.green,
              chart: _buildLightChart(),
            ),
            const SizedBox(height: 24),

            // AI Observations
            _buildAIObservations(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: ['Day', 'Week', 'Month'].map((period) {
          final isSelected = _selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = period),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.greenAccent[400] : transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required Color trendColor,
    required Widget chart,
  }) {
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
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trendColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trend.startsWith('+')
                          ? Icons.trending_up
                          : trend.startsWith('-')
                              ? Icons.trending_down
                              : Icons.check_circle,
                      color: trendColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: TextStyle(
                        color: trendColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          chart,
        ],
      ),
    );
  }

  Widget _buildTemperatureChart() {
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final values = [22.5, 23.2, 24.1, 23.8, 24.5, 23.9, 24.8];

    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomPaint(
              painter: LineChartPainter(values),
              size: const Size(double.infinity, 80),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) {
              return Text(
                day,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHumidityChart() {
    final values = [55, 50, 65, 60, 70, 58, 62];

    return SizedBox(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final height = (values[index] / 100) * 80;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 18,
                      height: height.toDouble(),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[400],
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(3)),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
              return Text(
                day,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoistureChart() {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: CurveChartPainter(),
              size: const Size(double.infinity, 80),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['06:00', '09:00', '12:00', '15:00', '18:00'].map((time) {
              return Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLightChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.83,
            minHeight: 8,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation(Colors.greenAccent[400]),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0 Lux',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
            ),
            Text(
              '5,000 Lux',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
            ),
            Text(
              '15,000 Lux',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAIObservations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Observations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildObservationItem(
          icon: Icons.info,
          color: Colors.green,
          title: 'Temperature Warning',
          description:
              'Peak detected at 14:00. Soil moisture level compensation recommended.',
        ),
        const SizedBox(height: 12),
        _buildObservationItem(
          icon: Icons.auto_awesome,
          color: Colors.green,
          title: 'Optimization Active',
          description:
              'Humidity is within the goldilocks zone for current pest control cycle.',
        ),
      ],
    );
  }

  Widget _buildObservationItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
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
                const SizedBox(height: 4),
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

class LineChartPainter extends CustomPainter {
  final List<double> values;

  LineChartPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (values.isEmpty) return;

    final minVal = values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final range = maxVal - minVal;

    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final normalized = (values[i] - minVal) / range;
      final y = size.height - (normalized * size.height);
      points.add(Offset(x, y));
    }

    // Draw fill
    final pathFill = Path()..moveTo(0, size.height);
    for (var point in points) {
      pathFill.lineTo(point.dx, point.dy);
    }
    pathFill.lineTo(size.width, size.height);
    pathFill.close();
    canvas.drawPath(pathFill, paint);

    // Draw line
    final pathLine = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      pathLine.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(pathLine, linePaint);
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) => true;
}

class CurveChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.3,
          size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.6,
          size.width, size.height * 0.4);

    final pathFill = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.3,
          size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.6,
          size.width, size.height * 0.4)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(pathFill, paint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(CurveChartPainter oldDelegate) => false;
}
