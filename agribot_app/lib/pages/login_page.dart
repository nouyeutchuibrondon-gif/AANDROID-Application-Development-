import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'operator@agribot.com');
  final _passwordController = TextEditingController(text: 'password');
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isFingerprintAvailable = true;
  bool _isFingerprintEnrolled = true;
  String _selectedRobotType = 'AGRIBOT-04';

  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color darkBg = Color(0xFF121212);

  static final List<String> robotTypes = [
    'AGRIBOT-01',
    'AGRIBOT-02',
    'AGRIBOT-03',
    'AGRIBOT-04',
    'AGRIBOT-05',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                DashboardPage(selectedRobot: _selectedRobotType),
          ),
        );
      }
    });
  }

  void _handleFingerprintLogin() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fingerprint recognized! Logging in...'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    DashboardPage(selectedRobot: _selectedRobotType),
              ),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [lightGreen, darkGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: lightGreen.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.agriculture,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 30),

              // Title
              const Text(
                'AGRIBOT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Agricultural Robot Control',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 40),

              // Email Field
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: lightGreen),
                  hintText: 'Email Address',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[900],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey[800]!,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: lightGreen,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: lightGreen),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[900],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey[800]!,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: lightGreen,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Fingerprint Login Button
              if (_isFingerprintAvailable)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isFingerprintEnrolled
                        ? _handleFingerprintLogin
                        : null,
                    icon: Icon(
                      Icons.fingerprint,
                      color: _isFingerprintEnrolled
                          ? Colors.black87
                          : Colors.grey[600],
                    ),
                    label: Text(
                      'Use Fingerprint',
                      style: TextStyle(
                        color: _isFingerprintEnrolled
                            ? Colors.black87
                            : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFingerprintEnrolled
                          ? Colors.greenAccent[400]
                          : Colors.grey[700],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Robot Type Selection
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[800]!,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[900],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Robot',
                      style: TextStyle(
                        color: lightGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: robotTypes.map((robot) {
                        bool isSelected = robot == _selectedRobotType;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRobotType = robot;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? lightGreen
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? lightGreen
                                    : Colors.grey[700]!,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              robot,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightGreen,
                    disabledBackgroundColor: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation(Colors.grey[800]),
                          ),
                        )
                      : const Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Guest Mode
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[800],
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[800],
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Demo Mode Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            DashboardPage(selectedRobot: _selectedRobotType),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: lightGreen, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'DEMO MODE',
                    style: TextStyle(
                      color: lightGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
