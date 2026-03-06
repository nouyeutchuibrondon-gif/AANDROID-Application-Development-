import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Color scheme
  static const Color darkBg = Color(0xFF0A2818);
  static const Color brightGreen = Color(0xFF00FF00);
  static const Color accentGreen = Color(0xFF1F4D2C);
  static const Color textGray = Color(0xFF8A9BA8);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
      }
    });
  }

  Widget _buildGoogleLogo() {
    return SizedBox(
      width: 24,
      height: 24,
      child: Image.asset(
        'assets/images/google_logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if image not found
          return Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF4285F4),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Center(
              child: Text(
                'G',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // System Status Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: brightGreen, width: 2),
                  borderRadius: BorderRadius.circular(24),
                  color: accentGreen.withOpacity(0.3),
                ),
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Blurred background image layer
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/farm_background.png',
                          fit: BoxFit.cover,
                          opacity: AlwaysStoppedAnimation(0.7),
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: darkBg,
                            );
                          },
                        ),
                      ),
                    ),
                    // Blur filter overlay
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                          child: Container(
                            color: brightGreen.withOpacity(0.08),
                          ),
                        ),
                      ),
                    ),
                    // Content on top
                    Column(
                      children: [
                        // Green Circle with Robot Icon
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: brightGreen,
                            boxShadow: [
                              BoxShadow(
                                color: brightGreen.withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.agriculture,
                            size: 70,
                            color: darkBg,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: brightGreen, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: const Text(
                            'SYSTEM ONLINE',
                            style: TextStyle(
                              color: brightGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title and Subtitle
            const Text(
              'AGRIBOT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Smart Pest-Control & Crop Monitoring',
              style: TextStyle(
                color: textGray,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 32),

            // Credentials Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email Field
                  const Text(
                    'Email or Username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: brightGreen),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: brightGreen,
                      ),
                      hintText: 'Enter your credentials',
                      hintStyle: const TextStyle(color: textGray),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: brightGreen, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: brightGreen, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: brightGreen, width: 2),
                      ),
                      filled: true,
                      fillColor: accentGreen.withOpacity(0.2),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Password Field with Forgot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot?',
                          style: TextStyle(
                            color: brightGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(color: brightGreen),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outlined,
                        color: brightGreen,
                      ),
                      hintText: '••••••••',
                      hintStyle: const TextStyle(color: brightGreen),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: brightGreen,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: brightGreen, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: brightGreen, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: brightGreen, width: 2),
                      ),
                      filled: true,
                      fillColor: accentGreen.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Biometric Login
            Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: brightGreen, width: 2),
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    color: brightGreen,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'BIOMETRIC LOGIN',
                  style: TextStyle(
                    color: brightGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Login Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: brightGreen.withOpacity(0.5),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(darkBg),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            color: darkBg,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sign Up Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    color: textGray,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: brightGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: textGray.withOpacity(0.3),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR CONTINUE WITH',
                      style: TextStyle(
                        color: textGray,
                        fontSize: 11,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: textGray.withOpacity(0.3),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Google Login Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: brightGreen, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGoogleLogo(),
                      const SizedBox(width: 12),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person_outline, color: textGray),
                    label: const Text(
                      'Switch Account',
                      style: TextStyle(
                        color: textGray,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.help_outline, color: textGray),
                    label: const Text(
                      'Support',
                      style: TextStyle(
                        color: textGray,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
