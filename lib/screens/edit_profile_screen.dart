import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trendveiw/components/buttton.dart';
import 'package:trendveiw/components/text_field.dart';
import 'dart:io'; // For File class

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
   final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
 /*  final TextEditingController _passwordController = TextEditingController(); */
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _selectedImage; // To store the picked image file
 bool _isUploading = false;
  String? _current64bytes; // To store existing image URL from Firestore

 
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBase64Image();
  }

 

   Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, // You can also use ImageSource.camera
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

   Future<Image?> getBase64Image() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?.containsKey('profileImageUrl') == true) {
        final base64String = doc['profileImageUrl'] as String;
        final userName = doc['username'];
        
setState(() {
  _current64bytes = base64String;
  _usernameController.text = user.displayName?? "";
  _emailController.text = user.email??"";
});

        
        
      }
    }
    return null;
  }

  Future<void> _saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to save profile')),
        );
        return;
      }

      /* String? imageUrl = _currentImageUrl; */
      
      // Upload new image if selected
      if (_selectedImage != null) {
        // Read the image file as bytes
      final bytes = await _selectedImage!.readAsBytes();
       // Convert to Base64
      final base64String = base64Encode(bytes);
       // Save all data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
            'username': _usernameController.text.trim(),
            'profileImageUrl': base64String,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

await user.updateDisplayName(
        _usernameController.text.trim(),
      );
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      }

     
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
   /*  _passwordController.dispose(); */
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Picture with edit icon
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!) // Show selected image
                          : (_current64bytes != null
                  ? MemoryImage(base64Decode(_current64bytes?? ""))
                  : const AssetImage('assets/default_avatar.png')) as ImageProvider, // Default image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Username field
              MyTextField(
                controller: _usernameController,
                hintText: 'Username',
              ),
              const SizedBox(height: 20),

              // Email field
              MyTextField(controller: _emailController, hintText: 'Email', enabled: false,),
              const SizedBox(height: 20),

              /* // Password field
              MyTextField(
                controller: _passwordController,
                hintText: 'Password',
              ),
              const SizedBox(height: 200), */

              // Save button
              MyButton(
                text: 'Save',
                onPressed: () {
                  // function to save edited profile
                  _saveProfile();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}