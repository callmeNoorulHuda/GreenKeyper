import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenkeyper/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greenkeyper',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Roboto'),
      home: const SplashScreen(), // ✅ Start from Splash
      debugShowCheckedModeBanner: false,
    );
  }
}
