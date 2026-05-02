import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/post_login_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  final String email;
  final String password;

  const UserDetailsScreen({super.key, required this.email, required this.password});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final currentLocationController = TextEditingController();
  final permanentLocationController = TextEditingController();
  final foodPreferenceController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Unified Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: _buildGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Personal Details',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),

                    _buildGlassInput(nameController, 'Full Name', Icons.person_outline),
                    _buildGlassInput(ageController, 'Age', Icons.calendar_today_outlined, type: TextInputType.number),
                    _buildGlassInput(genderController, 'Gender', Icons.wc_outlined),
                    _buildGlassInput(currentLocationController, 'Current City', Icons.location_on_outlined),
                    _buildGlassInput(permanentLocationController, 'Permanent Home Town', Icons.home_outlined),
                    _buildGlassInput(foodPreferenceController, 'Food Preferences', Icons.restaurant_outlined),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: isLoading ? null : _handleSignup,
                      child: isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Finish', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SHARED GLASS CARD UI
  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }

  // SHARED GLASS INPUT UI
  Widget _buildGlassInput(TextEditingController controller, String label, IconData icon, {TextInputType type = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70, size: 20),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  // SIGNUP LOGIC
  Future<void> _handleSignup() async {
    setState(() => isLoading = true);
    ///Android Emulator
    //final url = Uri.parse('http://10.0.2.2:8000/api/signup/');
    ///Isha
    //final url = Uri.parse('http://10.233.24.154:8000/api/signup/');
    ///JioFiber
    final url = Uri.parse('http://192.168.29.97:8000/api/signup/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": widget.email,
          "password": widget.password,
          "name": nameController.text,
          "age": int.tryParse(ageController.text) ?? 0,
          "gender": genderController.text,
          "current_location": currentLocationController.text,
          "permanent_location": permanentLocationController.text,
          "food_preferences": foodPreferenceController.text,
        }),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PostLoginScreen(
              permanentLocation: permanentLocationController.text,
            ),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server connection failed')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}