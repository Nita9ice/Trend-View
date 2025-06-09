import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/components/buttton.dart';
import 'package:trendveiw/components/text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Edit Profile", style: GoogleFonts.montserrat()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile Picture with edit icon
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/default_avatar.png',
                    ), // Replace with Firebase user image later
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 64, 129, 1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          //  implement image picker
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Username field
            MyTextField(controller: _usernameController, hintText: 'Username'),
            const SizedBox(height: 20),

            // Email field
            MyTextField(controller: _emailController, hintText: 'Email'),
            const SizedBox(height: 20),

            // password field
            MyTextField(controller: _passwordController, hintText: 'password'),
            const Spacer(),

            // Save button
            MyButton(
              text: 'save',
              onPressed: () {
                // function to save editted profile
              },
            ),
          ],
        ),
      ),
    );
  }
}
