import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriBot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E20)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const SplashScreen(),
      routes: {
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
