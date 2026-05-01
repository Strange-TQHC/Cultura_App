import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  final Map<String, dynamic>? knowledge;

  const LanguageScreen({super.key, this.knowledge});

  @override
  Widget build(BuildContext context) {
    if (knowledge == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Language & Folklore",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          _buildSectionCard(
            icon: Icons.language,
            title: "Languages",
            content: knowledge!['languages'],
          ),

          const SizedBox(height: 16),

          _buildSectionCard(
            icon: Icons.record_voice_over,
            title: "Common Phrases",
            content: knowledge!['phrases'],
          ),

          const SizedBox(height: 16),

          _buildSectionCard(
            icon: Icons.menu_book,
            title: "Folklore",
            content: knowledge!['folklore'],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.teal),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              content,
              style: const TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}