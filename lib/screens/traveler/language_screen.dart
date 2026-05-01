import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  final Map<String, dynamic>? knowledge;

  const LanguageScreen({super.key, this.knowledge});

  @override
  Widget build(BuildContext context) {
    if (knowledge == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Language & Folklore",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Languages: ${knowledge!['languages']}\n\n"
                  "Phrases: ${knowledge!['phrases']}\n\n"
                  "Folklore: ${knowledge!['folklore']}",
            ),
          ],
        ),
      ),
    );
  }
}