import 'package:flutter/material.dart';

class ControlPage extends StatefulWidget {
  final String selectedRobot;

  const ControlPage({
    super.key,
    this.selectedRobot = 'AGRIBOT-04',
  });

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  String _selectedDirection = '';
  double _cameraX = 0;
  double _cameraY = 0;
  bool _sprayActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.selectedRobot,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[400],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'LIVE LINK',
                  style: TextStyle(
                    color: Colors.greenAccent[400],
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.greenAccent[400], size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Cards Row
            Row(
              children: [
                Expanded(
                  child: _buildStatusCard(
                    icon: Icons.signal_cellular_alt,
                    title: 'Signal Strength',
                    value: '98%',
                    change: '+2%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatusCard(
                    icon: Icons.location_on_outlined,
                    title: 'Obstacle',
                    value: 'Clear',
                    change: '0m',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Camera/Map Feed with Touch Controls
            _buildInteractiveCameraFeed(),
            const SizedBox(height: 20),

            // Spray System Section
            _buildSpraySection(),
            const SizedBox(height: 20),

            // Joystick Control for Wheels
            _buildJoystickControl(),
            const SizedBox(height: 20),

            // Dock Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Docking sequence initiated...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[400],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '⬤ DOCK',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String value,
    required String change,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.greenAccent[400]!.withOpacity(0.4),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[900],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.greenAccent[400], size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                change,
                style: TextStyle(
                  color: Colors.greenAccent[400],
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveCameraFeed() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _cameraX += details.delta.dx * 0.5;
          _cameraY += details.delta.dy * 0.5;
          // Clamp values to reasonable pan/tilt range
          _cameraX = _cameraX.clamp(-50, 50);
          _cameraY = _cameraY.clamp(-50, 50);
        });
      },
      onPanEnd: (_) {
        // Smooth reset on release
        setState(() {
          _cameraX = 0;
          _cameraY = 0;
        });
      },
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.greenAccent[400]!.withOpacity(0.3),
            width: 2,
          ),
          color: Colors.black,
        ),
        child: Stack(
          children: [
            // Camera feed background (sunset field image or placeholder)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.orange[900]!,
                      Colors.amber[800]!,
                      Colors.green[900]!,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white.withOpacity(0.3),
                    size: 60,
                  ),
                ),
              ),
            ),

            // GPS Coordinates - Top Left and Right
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'LAT: 34.0522 N',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'LNG: 118.2437 W',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),

            // FPG and Temperature - Bottom Left
            Positioned(
              bottom: 12,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FPG: 60fps',
                    style: TextStyle(
                      color: Colors.greenAccent[400],
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'TEMP: 24°C',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),

            // Camera Control Button - Center
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue[400]!,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue[600]!.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.videocam,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),

            // Emergency/Record Button - Bottom Right
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.red[700],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red[400]!,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red[700]!.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

            // Camera Offset Indicator (for touch control feedback)
            if (_cameraX != 0 || _cameraY != 0)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[400],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Pan: ${_cameraX.toStringAsFixed(0)} Tilt: ${_cameraY.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpraySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SPRAY SYSTEM',
          style: TextStyle(
            color: Colors.greenAccent[400],
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[700]!,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent[400],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent[400]!.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.water_drop,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _sprayActive ? 'ACTIVE' : 'INACTIVE',
                style: TextStyle(
                  color: Colors.greenAccent[400],
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJoystickControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'WHEEL CONTROL - Manual Drive',
          style: TextStyle(
            color: Colors.greenAccent[400],
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 220,
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.greenAccent[400]!.withOpacity(0.5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[900],
            ),
            child: _buildJoystick(),
          ),
        ),
      ],
    );
  }

  Widget _buildJoystick() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer circle
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.greenAccent[400]!.withOpacity(0.3),
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
        ),

        // Directional overlays
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () => _setDirection('up'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedDirection == 'up'
                    ? Colors.greenAccent[400]
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.expand_less,
                color: _selectedDirection == 'up'
                    ? Colors.black
                    : Colors.greenAccent[400],
                size: 24,
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          child: GestureDetector(
            onTap: () => _setDirection('down'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedDirection == 'down'
                    ? Colors.greenAccent[400]
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.expand_more,
                color: _selectedDirection == 'down'
                    ? Colors.black
                    : Colors.greenAccent[400],
                size: 24,
              ),
            ),
          ),
        ),

        Positioned(
          left: 0,
          child: GestureDetector(
            onTap: () => _setDirection('left'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedDirection == 'left'
                    ? Colors.greenAccent[400]
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_left,
                color: _selectedDirection == 'left'
                    ? Colors.black
                    : Colors.greenAccent[400],
                size: 24,
              ),
            ),
          ),
        ),

        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: () => _setDirection('right'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedDirection == 'right'
                    ? Colors.greenAccent[400]
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_right,
                color: _selectedDirection == 'right'
                    ? Colors.black
                    : Colors.greenAccent[400],
                size: 24,
              ),
            ),
          ),
        ),

        // Center button
        GestureDetector(
          onTap: () => _stopMovement(),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.greenAccent[400],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent[400]!.withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.stop,
              color: Colors.black,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  void _setDirection(String direction) {
    setState(() {
      _selectedDirection = direction;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Robot moving: ${direction.toUpperCase()}'),
        duration: const Duration(seconds: 1),
      ),
    );

    // Auto reset after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _selectedDirection = '';
        });
      }
    });
  }

  void _stopMovement() {
    setState(() {
      _selectedDirection = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Robot STOPPED'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }
}
