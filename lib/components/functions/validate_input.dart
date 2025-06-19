import 'package:flutter/material.dart';
import 'package:trendveiw/components/dialog_box.dart';

bool validateInputs(
  BuildContext context,
  TextEditingController emailController,
  TextEditingController passwordController,
) {
  final email = emailController.text;
  final password = passwordController.text;

  if (email.isEmpty) {
    DialogBox.showErrorDialog(context, 'Please enter your email');
    return false;
  }
  if (!email.contains('@')) {
    DialogBox.showErrorDialog(context, 'Please enter a valid email address');
    return false;
  }
  if (password.isEmpty) {
    DialogBox.showErrorDialog(context, 'Please enter your password');
    return false;
  }
  if (password.length < 6) {
    DialogBox.showErrorDialog(
      context,
      'Password must be at least 6 characters',
    );
    return false;
  }
  return true;
}
