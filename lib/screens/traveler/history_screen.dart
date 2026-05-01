import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final Map<String, dynamic>? knowledge;

  const HistoryScreen({super.key, this.knowledge});

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
              "History & Culture",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text("${knowledge!['history']}\n\n${knowledge!['culture']}"),
          ],
        ),
      ),
    );
  }
}