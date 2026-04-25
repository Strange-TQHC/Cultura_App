import 'package:flutter/material.dart';
import '../../services/api/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/home_screen.dart';

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
      appBar: AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ),
                      (route) => false,
                );
              },
            ),
          ]

      ),
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