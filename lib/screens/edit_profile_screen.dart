import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trendveiw/components/util/buttton.dart';
import 'package:trendveiw/components/util/text_field.dart';
import 'package:trendveiw/components/util/dialog_box.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // FirebaseAuth instance used for handling user authentication.
  final FirebaseAuth auth = FirebaseAuth.instance;

  // FirebaseFirestore instance used for managing cloud database operations.
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Controller for handling input in the username text field
  final TextEditingController usernameController = TextEditingController();

  // Controller for handling input in the email text field
  final TextEditingController emailController = TextEditingController();

  // Stores the image file selected by the user from their device.
  File? selectedImage;

  // Stores the base64-encoded version of the selected profile image.
  String? current64bytes;

  // Indicates whether the profile is currently being saved (used to show loading state).
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    // Load user info when screen is initialized
    loadUserData();
  }

  // Fetch existing user data from Firestore and FirebaseAuth
  Future<void> loadUserData() async {
    final user = auth.currentUser;
    if (user == null) return;

    final doc = await firestore.collection('users').doc(user.uid).get();
    final data = doc.data();

    setState(() {
      usernameController.text = data?['username'] ?? user.displayName ?? '';
      emailController.text = user.email ?? '';
      current64bytes = data?['profileImageUrl'];
    });
  }

  // Opens the device gallery for the user to pick a new profile image
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
          // Convert path to File
          selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      DialogBox.showErrorDialog(context, 'Failed to pick image: $e');
    }
  }

  // Saves updated profile data to Firebase
  Future<void> _saveProfile() async {
    final user = auth.currentUser;
    if (user == null) return;

    setState(() => isSaving = true);

    try {
      String? newBase64Image = current64bytes;

      if (selectedImage != null) {
        final bytes = await selectedImage!.readAsBytes();
        newBase64Image = base64Encode(bytes); // Convert image to base64
      }

      // Save updated username and image to Firestore
      await firestore.collection('users').doc(user.uid).set({
        'username': usernameController.text.trim(),
        'profileImageUrl': newBase64Image,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update FirebaseAuth user display name
      await user.updateDisplayName(usernameController.text.trim());

      // Update FirebaseAuth email (triggers verification)
      final newEmail = emailController.text.trim();
      if (newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);
      }

      if (!mounted) return;
      DialogBox.showSuccessDialog(context, 'Profile updated successfully!');
    } catch (e) {
      if (!mounted) return;
      DialogBox.showErrorDialog(context, 'Failed to update profile: $e');
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free memory
    usernameController.dispose();
    emailController.dispose();
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
          onPressed:
              () => Navigator.pop(
                context,
              ), // Return to previous screen (profile screen)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile image with edit icon overlay
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        selectedImage != null
                            ? FileImage(selectedImage!)
                            : (current64bytes != null
                                ? MemoryImage(base64Decode(current64bytes!))
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
                        onPressed: _pickImage, // Pick new image from gallery
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Username input field
            MyTextField(controller: usernameController, hintText: 'Username'),

            const SizedBox(height: 16),

            // Email input field
            MyTextField(controller: emailController, hintText: 'Email'),

            const SizedBox(height: 30),

            // Save button (disabled if already saving)
            MyButton(
              text: 'Save Changes',
              onPressed:
                  isSaving
                      ? () {} // Do nothing if already saving
                      : () {
                        _saveProfile();
                        // Go back after saving
                        Navigator.pop(context);
                      },
            ),
          ],
        ),
      ),
    );
  }
}
