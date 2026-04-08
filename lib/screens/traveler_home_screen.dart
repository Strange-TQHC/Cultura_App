import 'package:flutter/material.dart';

class TravelerHomeScreen extends StatelessWidget {
  const TravelerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CULTURA - Traveler'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TOP INFO CARD
            _buildTopCard(),

            const SizedBox(height: 20),

            _buildSection("Nearby Highlights"),
            _buildSection("History & Culture"),
            _buildSection("Food & Etiquette"),
            _buildSection("Local Language & Folklores"),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: const Icon(Icons.location_on),
        title: const Text("Current Location"),
        subtitle: const Text("Fetching..."),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Time"),
            Text("Weather"),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 120,
                  alignment: Alignment.center,
                  child: Text("$title\nItem ${index + 1}"),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}