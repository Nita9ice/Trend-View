import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController _usernameController = TextEditingController();
  String? _email;
  String? _imageUrl;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile({int retries = 3}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    int attempt = 0;
    while (attempt < retries) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (!mounted) return;
        setState(() {
          _email = user.email;
          _usernameController.text = doc.data()?['username'] ?? '';
          _imageUrl = doc.data()?['imageUrl'];
          _isLoading = false;
        });
        return; // Success
      } catch (e) {
        attempt++;
        if (attempt >= retries) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to load profile. Please try again later.'),
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
        await Future.delayed(Duration(seconds: 2 * attempt)); // Backoff
      }
    }
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'username': _usernameController.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        File file = File(picked.path);
        final ref = _storage.ref(
          'profile_images/${_auth.currentUser!.uid}.jpg',
        );
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
          {'imageUrl': downloadUrl},
        );
        if (!mounted) return;
        setState(() {
          _imageUrl = downloadUrl;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            _imageUrl != null
                                ? NetworkImage(_imageUrl!)
                                : const AssetImage(
                                      'assets/profile_placeholder.png',
                                    )
                                    as ImageProvider,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _email ?? '',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
    );
  }
}
