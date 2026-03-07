import 'package:flutter/material.dart';
import '../services/telemetry_service.dart';
import '../models/telemetry_data.dart';
import 'activity_logs_page.dart';
import 'bot_details_page.dart';
import 'environmental_data_page.dart';
import 'control_page.dart';
import 'crop_info_page.dart';
import 'reports_page.dart';
import 'analytics_page.dart';
import 'map_page.dart';
import 'settings_page.dart';
import 'camera_fullscreen.dart';

class DashboardPage extends StatefulWidget {
  final String selectedRobot;

  const DashboardPage({
    super.key,
    this.selectedRobot = 'AGRIBOT-04',
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TelemetryService _telemetryService;
  late TelemetryData _telemetryData;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _telemetryService = TelemetryService();
    _telemetryService.initialize();
    _telemetryData = _telemetryService.currentData;
  }

  @override
  void dispose() {
    _telemetryService.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _selectedIndex == 0
        ? _buildHomePageContent()
        : _buildTabPageContent();
  }

  Widget _buildHomePageContent() {
    return StreamBuilder<TelemetryData>(
      stream: _telemetryService.dataStream,
      initialData: _telemetryData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _telemetryData = snapshot.data!;
        }
        return _buildHomePage();
      },
    );
  }

  Widget _buildTabPageContent() {
    switch (_selectedIndex) {
      case 1:
        return const CropInfoPage();
      case 2:
        return const EnvironmentalDataPage();
      case 3:
        return const ReportsPage();
      case 4:
        return const AnalyticsPage();
      default:
        return _buildHomePageContent();
    }
  }

  Widget _buildHomePage() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        elevation: 0,
        title: Column(
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
            Text(
              'Smart Agricultural Robot',
              style: TextStyle(
                color: Colors.greenAccent[400],
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              Icons.notifications,
              color: Colors.greenAccent[400],
              size: 28,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStatusCard(),
            const SizedBox(height: 20),
            _buildBatteryAndModeSection(),
            const SizedBox(height: 20),
            _buildCameraFeedsSection(),
            const SizedBox(height: 20),
            _buildQuickActionsGrid(),
            const SizedBox(height: 20),
            _buildEnvironmentalAnalytics(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1B5E20),
        selectedItemColor: Colors.greenAccent[400],
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco),
            label: 'CROP',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'DATA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'REPORTS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'ANALYTICS',
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('assets/images/farm_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.green.withOpacity(0.6),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SYSTEM STATUS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Status: Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'All systems operational',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
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

  Widget _buildBatteryAndModeSection() {
    final batteryColor = _telemetryData.batteryLevel > 50
        ? Colors.greenAccent[400]
        : _telemetryData.batteryLevel > 20
            ? Colors.orange
            : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
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
                    'BATTERY',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.battery_full,
                        color: batteryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_telemetryData.batteryLevel}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _telemetryData.batteryLevel / 100,
                      minHeight: 6,
                      backgroundColor: Colors.grey[700],
                      valueColor: AlwaysStoppedAnimation(batteryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
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
                    'MODE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.greenAccent[400],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _telemetryData.mode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Autonomous mode',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
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
                child: _buildQuickActionCard(
                  'Control',
                  Icons.gamepad,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ControlPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Bot Details',
                  Icons.devices,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BotDetailsPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Map',
                  Icons.map,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Settings',
                  Icons.settings,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Activity Logs',
                  Icons.history,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ActivityLogsPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraFeedsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Feed',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'ALL CAMERAS',
                style: TextStyle(
                  color: Colors.greenAccent[400],
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Three cameras in a row: Left | Front (center) | Right
          Row(
            children: [
              // LEFT CAMERA - Insect Detection
              Expanded(
                child: GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraFullscreenPage(
                          title: 'Left Camera - Insect Detection',
                          backgroundColor: Colors.orange[900]!,
                          icon: Icons.bug_report,
                        ),
                      ),
                    );
                  },
                  child: _buildLiveCamera(
                    title: 'Left View',
                    subtitle: 'Insect Detection',
                    icon: Icons.bug_report,
                    status: 'ACTIVE',
                    statusColor: Colors.orange[400]!,
                    backgroundColor: Colors.orange[900]!,
                    data: 'Pests: 3 | Conf: 92%',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // FRONT CAMERA - Navigation (Center/Larger)
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ControlPage(selectedRobot: widget.selectedRobot),
                      ),
                    );
                  },
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraFullscreenPage(
                          title: 'Front Camera - Navigation',
                          backgroundColor: Colors.green[900]!,
                          icon: Icons.location_on,
                          isMainCamera: true,
                        ),
                      ),
                    );
                  },
                  child: _buildLiveCamera(
                    title: 'Front View',
                    subtitle: 'Navigation & Path Tracking',
                    icon: Icons.location_on,
                    status: 'ACTIVE',
                    statusColor: Colors.green[400]!,
                    backgroundColor: Colors.green[900]!,
                    data: 'Heading: NE | Dist: 2.5m',
                    isMainCamera: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // RIGHT CAMERA - Insect Detection
              Expanded(
                child: GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraFullscreenPage(
                          title: 'Right Camera - Insect Detection',
                          backgroundColor: Colors.orange[900]!,
                          icon: Icons.bug_report,
                        ),
                      ),
                    );
                  },
                  child: _buildLiveCamera(
                    title: 'Right View',
                    subtitle: 'Insect Detection',
                    icon: Icons.bug_report,
                    status: 'ACTIVE',
                    statusColor: Colors.orange[400]!,
                    backgroundColor: Colors.orange[900]!,
                    data: 'Pests: 2 | Conf: 88%',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // View Full Telemetry Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EnvironmentalDataPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent[400],
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'VIEW FULL TELEMETRY',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveCamera({
    required String title,
    required String subtitle,
    required IconData icon,
    required String status,
    required Color statusColor,
    required Color backgroundColor,
    required String data,
    bool isMainCamera = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.6),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Camera Video Area
          Container(
            height: isMainCamera ? 180 : 140,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Stack(
              children: [
                // Camera feed background with icon
                Center(
                  child: Icon(
                    icon,
                    size: isMainCamera ? 70 : 50,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                // Status Badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Recording indicator
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        'REC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Camera Info
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 9,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    data,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 9,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.greenAccent[400]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.greenAccent[400], size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentalAnalytics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Environmental Analytics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  title: 'TEMP',
                  value: '${_telemetryData.temperature.toStringAsFixed(1)}°',
                  unit: 'celsius',
                  color: Colors.orange,
                  percentage: _telemetryData.temperature / 40,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnalyticsCard(
                  title: 'HUMIDITY',
                  value: '${_telemetryData.humidity.toStringAsFixed(0)}%',
                  unit: 'rh',
                  color: Colors.greenAccent,
                  percentage: _telemetryData.humidity / 100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  title: 'MOISTURE',
                  value: '${_telemetryData.moisture.toStringAsFixed(0)}%',
                  unit: 'sm',
                  color: Colors.brown,
                  percentage: _telemetryData.moisture / 100,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnalyticsCard(
                  title: 'LIGHT',
                  value: '${_telemetryData.light.toStringAsFixed(0)}lux',
                  unit: 'lux',
                  color: Colors.greenAccent,
                  percentage: _telemetryData.light / 1000,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
    required double percentage,
  }) {
    final bars = <bool>[
      percentage > 0.2,
      percentage > 0.4,
      percentage > 0.6,
      percentage > 0.8,
      percentage > 1.0,
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              5,
              (index) => Container(
                width: 6,
                height: 30,
                decoration: BoxDecoration(
                  color: bars[index] ? color : Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
