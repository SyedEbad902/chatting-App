import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/toast_service.dart';
import 'package:chatapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ValidationProvider extends ChangeNotifier {
  final _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;
  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;
  final _confirmPasswordController = TextEditingController();
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;
  final toastProvider = getIt<ToastService>();

  String? _validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      // return 'Please enter your email';
      toastProvider.DelightToast(
              text: "Enter your email",
              icon: Icons.cancel,
              circleColor: Colors.white,
              iconColor: Colors.red,
              context: context)
          .show(context);
    }
    // Simple email validation pattern
    String pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9.]+.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      toastProvider.DelightToast(
              text: "Enter a valid email",
              icon: Icons.cancel,
              circleColor: Colors.white,
              iconColor: Colors.red,
              context: context)
          .show(context);
      // return 'Enter a valid email address';
    }
    return null;
  }

  // Helper function to validate password strength
  String? _validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      // return 'Please enter a password';
    }
    if (value!.length < 6) {
      // return 'Password must be at least 6 characters';
      toastProvider.DelightToast(
              text: "Password must be at least 6 characters",
              icon: Icons.cancel,
              circleColor: Colors.white,
              iconColor: Colors.red,
              context: context)
          .show(context);
    }
    return null;
  }

  // Helper function to confirm password match
  String? _validateConfirmPassword(
      String password, String confirmPassword, BuildContext context) {
    if (confirmPassword.isEmpty) {
      // return 'Please confirm your password';
      toastProvider.DelightToast(
              text: "Please confirm your password",
              icon: Icons.cancel,
              circleColor: Colors.white,
              iconColor: Colors.red,
              context: context)
          .show(context);
    } else if (password != confirmPassword) {
      // return 'Passwords do not match';
      toastProvider.DelightToast(
              text: "Passwords do not match",
              icon: Icons.cancel,
              circleColor: Colors.white,
              iconColor: Colors.red,
              context: context)
          .show(context);
    }
    return null;
  }

  String? _passwordError;
  String? get passwordError => _passwordError;

  String? _emailError;
  String? get emailError => _emailError;

  String? _confirmPasswordError;
  String? get confirmPasswordError => _confirmPasswordError;

  // void _submitForm() {
  //   setState(() {
  //     // Manually validate the password when the user submits the form
  //     _passwordError = _validatePassword(_passwordController.text);
  //     _emailError = _validatePassword(_passwordController.text);
  //     _confirmPasswordError = _validatePassword(_passwordController.text);
  //   });
  // }
  void submitForm(BuildContext context) {
    final authProvider =
        Provider.of<FirebaseAuthService>(context, listen: false);
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      toastProvider.DelightToast(
              text: "Fill the field first",
              icon: Icons.cancel,
              circleColor: Colors.white,
              iconColor: Colors.red,
              context: context)
          .show(context);
    } else {
      // Manually validate the fields
      _emailError = _validateEmail(_emailController.text, context);
      _passwordError = _validatePassword(_passwordController.text, context);
      _confirmPasswordError = _validateConfirmPassword(
          _passwordController.text, _confirmPasswordController.text, context);
      notifyListeners();
    }

    // If all fields are valid, show SnackBar
    if (_emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null) {
      authProvider.createUser(
          _emailController.text, _passwordController.text, context);
      notifyListeners();
    }
  }
}
