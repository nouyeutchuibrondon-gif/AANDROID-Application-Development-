import 'package:flutter/material.dart';

class ActivityLogsPage extends StatefulWidget {
  const ActivityLogsPage({super.key});

  @override
  State<ActivityLogsPage> createState() => _ActivityLogsPageState();
}

class _ActivityLogsPageState extends State<ActivityLogsPage> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<LogEntry> _allLogs = [
    LogEntry(
      title: 'Target identified and treated',
      description:
          'Pest detected and neutralised in Sector B-12 using precision sprayers.',
      timestamp: '10:45 AM',
      category: 'PEST CONTROL',
      icon: Icons.check_circle,
      color: Colors.green,
    ),
    LogEntry(
      title: 'Battery levels low',
      description:
          'Battery at 15%. Robot is rerouting to the nearest solar charging station.',
      timestamp: '09:12 AM',
      category: 'POWER MANAGEMENT',
      icon: Icons.warning,
      color: Colors.orange,
    ),
    LogEntry(
      title: 'Navigation calibration',
      description:
          'LIDAR and GPS sensors successfully recalibrated for high-density terrain.',
      timestamp: '08:30 AM',
      category: 'NAVIGATION',
      icon: Icons.info,
      color: Colors.blue,
    ),
    LogEntry(
      title: 'Moisture map updated',
      description:
          'Soil analysis complete for Zone A-4. Syncing data with Central Hub.',
      timestamp: '07:45 AM',
      category: 'ANALYSIS',
      icon: Icons.rss_feed,
      color: Colors.greenAccent,
    ),
    LogEntry(
      title: 'Daily routine started',
      description:
          'Autonomous patrol initiated for East Vineyard sections.',
      timestamp: '06:00 AM',
      category: 'SYSTEM',
      icon: Icons.play_circle,
      color: Colors.green,
    ),
  ];

  List<LogEntry> get _filteredLogs {
    var filtered = _allLogs;
    if (_selectedFilter != 'All') {
      filtered =
          filtered.where((log) => log.category == _selectedFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((log) =>
              log.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              log.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Activity Logs'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.greenAccent[400]),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 16),

            // Filter Tabs
            _buildFilterTabs(),
            const SizedBox(height: 16),

            // Logs List
            _buildLogsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search activity logs...',
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Navigation', 'Pest Control', 'Battery'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedFilter = filter);
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

  Widget _buildLogsList() {
    return Column(
      children: _filteredLogs.map((log) => _buildLogItem(log)).toList(),
    );
  }

  Widget _buildLogItem(LogEntry log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: log.color.withOpacity(0.1),
        border: Border.all(color: log.color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: log.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(log.icon, color: log.color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  log.description,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  log.category,
                  style: TextStyle(
                    color: log.color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            log.timestamp,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class LogEntry {
  final String title;
  final String description;
  final String timestamp;
  final String category;
  final IconData icon;
  final Color color;

  LogEntry({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
    required this.icon,
    required this.color,
  });
}
