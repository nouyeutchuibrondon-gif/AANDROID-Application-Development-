import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _autoModeEnabled = true;
  bool _gpsEnabled = true;
  bool _fingerprintEnabled = true;
  bool _fingerprintEnrolled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('SETTINGS'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Device Settings'),
            _buildToggleSetting(
              'Auto Mode',
              'Enable autonomous operation',
              _autoModeEnabled,
              (value) {
                setState(() => _autoModeEnabled = value);
              },
            ),
            _buildToggleSetting(
              'GPS Tracking',
              'Real-time location tracking',
              _gpsEnabled,
              (value) {
                setState(() => _gpsEnabled = value);
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Notifications'),
            _buildToggleSetting(
              'Enable Notifications',
              'Receive alerts and updates',
              _notificationsEnabled,
              (value) {
                setState(() => _notificationsEnabled = value);
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('System Info'),
            _buildInfoTile('Device ID', 'AGRIBOT-2024-001'),
            _buildInfoTile('Firmware Version', 'v2.4.1'),
            _buildInfoTile('Battery Health', '98%'),
            _buildInfoTile('Last Updated', 'Mar 6, 2026'),
            const SizedBox(height: 24),
            _buildSectionTitle('Account'),
            _buildSettingButton(
              'Change Password',
              Icons.lock,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Change Password')),
                );
              },
            ),
            _buildSettingButton(
              'Manage Devices',
              Icons.devices,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Manage Devices')),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Security'),
            _buildToggleSetting(
              'Fingerprint Login',
              'Use biometric authentication to login',
              _fingerprintEnabled,
              (value) {
                setState(() => _fingerprintEnabled = value);
                if (value && !_fingerprintEnrolled) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No fingerprints enrolled. Add one first.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  setState(() => _fingerprintEnabled = false);
                }
              },
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.fingerprint,
                    color: _fingerprintEnrolled ? Colors.greenAccent[400] : Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _fingerprintEnrolled ? 'Fingerprint: Enrolled' : 'Fingerprint: Not Enrolled',
                      style: TextStyle(
                        color: _fingerprintEnrolled ? Colors.greenAccent[400] : Colors.grey[400],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildSecurityButtonSmall(
                    _fingerprintEnrolled ? 'Update Fingerprint' : 'Add Fingerprint',
                    Icons.fingerprint,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_fingerprintEnrolled ? 'Updating fingerprint...' : 'Adding fingerprint...'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() => _fingerprintEnrolled = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fingerprint enrolled successfully!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                if (_fingerprintEnrolled)
                  Expanded(
                    child: _buildSecurityButtonSmall(
                      'Remove',
                      Icons.delete_outline,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fingerprint removed'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        setState(() {
                          _fingerprintEnrolled = false;
                          _fingerprintEnabled = false;
                        });
                      },
                      isRemove: true,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Danger Zone'),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'LOG OUT',
                  style: TextStyle(
                    color: Colors.white,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildToggleSetting(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.greenAccent[400],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
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
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton(
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.greenAccent[400]),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.grey, size: 16),
        onTap: onPressed,
      ),
    );
  }

  Widget _buildSecurityButtonSmall(
    String title,
    IconData icon,
    VoidCallback onPressed, {
    bool isRemove = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isRemove ? Colors.red[700] : Colors.greenAccent[400],
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: isRemove ? Colors.white : Colors.black87, size: 16),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              color: isRemove ? Colors.white : Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Log Out?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.grey[400]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
