import 'package:flutter/material.dart';

class FoodScreen extends StatelessWidget {
  final Map<String, dynamic>? knowledge;

  const FoodScreen({super.key, this.knowledge});

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
              "Food & Etiquette",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text("${knowledge!['food']}\n\n${knowledge!['etiquette']}"),
          ],
        ),
      ),
    );
  }
}