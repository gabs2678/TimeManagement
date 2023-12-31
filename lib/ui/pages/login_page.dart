import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orbit/ui/theme.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SupabaseClient supabase;

  LoginPage({required this.supabase});

// Function to save user ID in local storage after logging in
Future<void> saveUserIdToLocalStorage(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
  print('User ID saved to local storage: $userId');
}

  Future<void> loginUser(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final response = await supabase.auth.signIn(email:email, password:password);
      if (response.error != null) {
        // Error occurred during login
        // Handle error - Show error message or snackbar to inform the user
        print('Error signing in: ${response.error!.message}');
        return;
      }
      var user = supabase.auth.user();

      saveUserIdToLocalStorage(user!.id);

      // User login successful
      // Redirect to home page or perform further actions
      Get.offNamed('/home');
    } catch (error) {
      // Exception occurred during login
      // Handle exception - Show error message or snackbar to inform the user
      print('Exception during sign in: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Login'),
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
            SizedBox(height: 24.0),
             ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:primaryClr.withOpacity(1), // Set the button background color to red
              ),
              onPressed: () {
                loginUser(context); // Call function to log in user
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Get.toNamed('/signup'); // Navigate to SignUpPage when "Sign Up" is pressed
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
