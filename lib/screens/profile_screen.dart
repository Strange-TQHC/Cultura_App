import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  List contributions = [];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    final profile = await ProfileService.getProfile();
    final myContributions = await ProfileService.getMyContributions();

    setState(() {
      user = profile;
      contributions = myContributions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${user!['username']}"),
            Text("Email: ${user!['email']}"),

            const SizedBox(height: 20),

            const Text(
              "My Contributions",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: contributions.length,
                itemBuilder: (context, index) {
                  final c = contributions[index];
                  return ListTile(
                    title: Text(c['category']),
                    subtitle: Text(c['content']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}