// lib/screens/demo_screen.dart
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class DemoScreen2 extends StatelessWidget {
  const DemoScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    // Automatically navigate to dashboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
