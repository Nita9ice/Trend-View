import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trendveiw/components/buttton.dart';
import 'package:trendveiw/components/text_field.dart';
import 'package:trendveiw/components/dialog_box.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Instance of AuthService to handle user authentication logic
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firebase Firestore instance used to read and write data to the cloud database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controller for handling input in the username text field
  final TextEditingController _usernameController = TextEditingController();

  // Controller for handling input in the email text field
  final TextEditingController _emailController = TextEditingController();

  // Holds the selected image file from the user's device
  File? _selectedImage;

  // Stores the base64-encoded string of the selected image
  String? _current64bytes;

  // Indicates whether a save operation is currently in progress
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data();

    setState(() {
      _usernameController.text = data?['username'] ?? user.displayName ?? '';
      _emailController.text = user.email ?? '';
      _current64bytes = data?['profileImageUrl'];
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      DialogBox.showErrorDialog(context, 'Failed to pick image: $e');
    }
  }

  Future<void> _saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      String? newBase64Image = _current64bytes;

      if (_selectedImage != null) {
        final bytes = await _selectedImage!.readAsBytes();
        newBase64Image = base64Encode(bytes);
      }

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'username': _usernameController.text.trim(),
        'profileImageUrl': newBase64Image,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update FirebaseAuth display name
      await user.updateDisplayName(_usernameController.text.trim());

      // Update email if changed
      final newEmail = _emailController.text.trim();
      if (newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);
      }

      if (!mounted) return;
      DialogBox.showSuccessDialog(context, 'Profile updated successfully!');
    } catch (e) {
      if (!mounted) return;
      DialogBox.showErrorDialog(context, 'Failed to update profile: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current app theme (light or dark)
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.montserrat(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.headlineLarge?.color,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (_current64bytes != null
                                ? MemoryImage(base64Decode(_current64bytes!))
                                : const AssetImage('assets/default_avatar.png')
                                    as ImageProvider),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // username field
            MyTextField(controller: _usernameController, hintText: 'Username'),
            const SizedBox(height: 16),
            // email field
            MyTextField(controller: _emailController, hintText: 'Email'),
            const SizedBox(height: 16),

            const SizedBox(height: 30),

            // save changes button
            MyButton(
              text: 'Save Changes',
              onPressed:
                  _isSaving
                      ? () {}
                      : () {
                        _saveProfile();
                        Navigator.pop(context);
                      },
            ),
          ],
        ),
      ),
    );
  }
}
