import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trendveiw/components/dialog_box.dart';
import 'package:trendveiw/components/functions/validate_input.dart';
import 'package:trendveiw/services/auth_service.dart';

Future<void> loginUser({
  required BuildContext context,
  required AuthService authService,
  required TextEditingController emailController,
  required TextEditingController passwordController,
}) async {
  if (validateInputs(context, emailController, passwordController)) {
    try {
      final userCredential = await authService.loginUser(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (userCredential != null) {
        if (userCredential.user?.emailVerified ?? false) {
          Navigator.pushNamed(context, '/wrapper');
        } else {
          DialogBox.showInfoDialog(
            context,
            'Email Verification Required',
            'Please verify your email before logging in.',
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Incorrect email or password';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password provided.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      }

      DialogBox.showErrorDialog(context, errorMessage);
    } catch (e) {
      DialogBox.showErrorDialog(context, 'An unexpected error occurred.');
    }
  }
}
