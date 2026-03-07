import 'package:flutter/material.dart';

class CameraFullscreenPage extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final IconData icon;
  final bool isMainCamera;

  const CameraFullscreenPage({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.icon,
    this.isMainCamera = false,
  });

  @override
  State<CameraFullscreenPage> createState() => _CameraFullscreenPageState();
}

class _CameraFullscreenPageState extends State<CameraFullscreenPage> {
  double _zoom = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _zoom += details.delta.dx * 0.001;
                  _zoom = _zoom.clamp(1.0, 5.0);
                });
              },
              onVerticalDragUpdate: (details) {
                // Can be used for tilt control
              },
              child: Transform.scale(
                scale: _zoom,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.backgroundColor,
                        widget.backgroundColor.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.icon,
                          size: 120,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Live Camera Feed',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Tap to zoom | Swipe to adjust',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Bottom Controls
          Container(
            color: Colors.grey[900],
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isMainCamera)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Navigation Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataRow('Heading', 'NE (45°)'),
                            _buildDataRow('Distance', '2.5 meters'),
                            _buildDataRow('Speed', '0.5 m/s'),
                            _buildDataRow('GPS Latitude', '34.0522°N'),
                            _buildDataRow('GPS Longitude', '118.2437°W'),
                            _buildDataRow('Path Confidence', '94%'),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pest Detection Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataRow('Pests Detected', '3 clusters'),
                            _buildDataRow('Confidence Level', '92%'),
                            _buildDataRow('Species', 'Aphids detected'),
                            _buildDataRow('Location', 'Row 12, Section B'),
                            _buildDataRow('Threat Level', 'Medium'),
                            _buildDataRow('Recommended Action', 'Targeted spray'),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
              color: Colors.greenAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
