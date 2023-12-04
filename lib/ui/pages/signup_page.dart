import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final SupabaseClient supabase;

  SignUpPage({required this.supabase});

  Future<void> registerUser(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    print(email);
    print(password);

    if (password != confirmPassword) {
      // Passwords don't match
      // Show error message or snackbar to inform the user
      return;
    }

    try {
      final response = await supabase.auth.signUp(email, password);
      if (response.error != null) {
        // Error occurred during registration
        // Handle error - Show error message or snackbar to inform the user
        print('Error signing up: ${response.error!.message}');
        return;
      }

      // User registration successful
      // Redirect to home page or perform further actions
      Get.offNamed('/home');
    } catch (error) {
      // Exception occurred during registration
      // Handle exception - Show error message or snackbar to inform the user
      print('Exception during sign up: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                registerUser(context); // Call function to register user
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Get.back(); // Navigate back to the login page
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
