// lib/screens/profile_page.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await DatabaseHelper().getProfile();
    setState(() {
      _profile = data;
    });
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty) return;

    await DatabaseHelper().insertProfile({
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
    });

    await _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (_profile != null) {
      // Show saved profile
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            Text(
              _profile!['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_profile!['email'] != null && _profile!['email'].isNotEmpty)
              Text("Email: ${_profile!['email']}"),
            if (_profile!['phone'] != null && _profile!['phone'].isNotEmpty)
              Text("Phone: ${_profile!['phone']}"),
          ],
        ),
      );
    }

    // Show form to add profile details
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Create Profile",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: "Phone"),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveProfile,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
