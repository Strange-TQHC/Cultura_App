import 'package:flutter/material.dart';
import 'screens/auth/splash_check_screen.dart';

void main() {
  runApp(const CulturaApp());
}

class CulturaApp extends StatelessWidget {
  const CulturaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CULTURA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const SplashCheckScreen(),
    );
  }
}