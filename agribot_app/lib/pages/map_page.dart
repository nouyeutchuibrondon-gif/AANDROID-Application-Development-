import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('FIELD MAP'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Map placeholder
          Container(
            color: Colors.grey[800],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Field Map',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Real-time GPS tracking and coverage map',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Map controls
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                _buildMapButton(Icons.add),
                const SizedBox(height: 8),
                _buildMapButton(Icons.remove),
              ],
            ),
          ),
          // Status overlay
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Farm North Block - Sector A',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.speed, color: Colors.greenAccent,
                          size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Speed: 2.5 km/h',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.compass_calibration,
                          color: Colors.greenAccent, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Heading: NE',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.greenAccent[400]),
        iconSize: 24,
      ),
    );
  }
}
