import 'package:flutter/material.dart';
import 'dart:ui';

class HistoryScreen extends StatelessWidget {
  final Map<String, dynamic>? knowledge;
  const HistoryScreen({super.key, this.knowledge});

  @override
  Widget build(BuildContext context) {
    if (knowledge == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("History & Heritage",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1)),
            const SizedBox(height: 25),
            _buildGlassCard(
              icon: Icons.history_toggle_off_rounded,
              title: "The Timeline",
              content: knowledge!['history'],
              accentColor: Colors.indigo,
            ),
            const SizedBox(height: 20),
            _buildGlassCard(
              icon: Icons.auto_awesome_mosaic_rounded,
              title: "Cultural Essence",
              content: knowledge!['culture'],
              accentColor: Colors.deepPurpleAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({required IconData icon, required String title, required String content, required Color accentColor}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: accentColor.withOpacity(0.2),
                    child: Icon(icon, color: accentColor),
                  ),
                  const SizedBox(width: 15),
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 15),
              Text(content, style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.6)),
            ],
          ),
        ),
      ),
    );
  }
}