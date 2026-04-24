import 'package:flutter/material.dart';
import '../services/add_contribution_service.dart';

class AddContributionScreen extends StatefulWidget {
  final int placeId;

  const AddContributionScreen({super.key, required this.placeId});

  @override
  State<AddContributionScreen> createState() => _AddContributionScreenState();
}

class _AddContributionScreenState extends State<AddContributionScreen> {
  final TextEditingController _contentController = TextEditingController();
  String selectedCategory = 'food';

  void submit() async {
    final success = await AddContributionService.addContribution(
      placeId: widget.placeId,
      category: selectedCategory,
      content: _contentController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contribution added")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Contribution")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              items: const [
                DropdownMenuItem(value: 'food', child: Text("Food")),
                DropdownMenuItem(value: 'history', child: Text("History")),
                DropdownMenuItem(value: 'folklore', child: Text("Folklore")),
                DropdownMenuItem(value: 'etiquette', child: Text("Etiquette")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: "Write something...",
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submit,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}