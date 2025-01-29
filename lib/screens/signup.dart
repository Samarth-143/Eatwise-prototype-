import 'package:flutter/material.dart';
import 'details.dart'; // Import the meal planner screen

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 60.0), // Top margin
            // Name Field
            _buildTextField(label: "Name", hint: "Enter your name"),
            SizedBox(height: 15),
            // Phone Field
            _buildTextField(label: "Phone", hint: "Enter your phone number"),
            SizedBox(height: 15),
            // Email Field
            _buildTextField(label: "Email", hint: "Enter your email"),
            SizedBox(height: 15),
            // Password Field
            _buildTextField(
              label: "Password",
              hint: "Enter your password",
              obscureText: true,
            ),
            SizedBox(height: 15),
            // Confirm Password Field
            _buildTextField(
              label: "Confirm Password",
              hint: "Confirm your password",
              obscureText: true,
            ),
            SizedBox(height: 30),
            // Sign Up Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Navigate to MealPlannerScreen after sign up
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealPlannerScreen()),
                );
              },
              child: const Text(
                'Sign up',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            // OR Divider
            Row(
              children: const [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('OR'),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),
            SizedBox(height: 20),
            // Google Sign Up Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: Image.asset('assets/images/google.png', width: 24, height: 24),
              label: const Text(
                'Sign in with Google',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              onPressed: () {
                // Google Sign in logic here
              },
            ),
            SizedBox(height: 20),
            // Sign in text
            TextButton(
              onPressed: () {
                // Navigate to Sign in page
              },
              child: const Text(
                'Sign in',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField({
    required String label,
    required String hint,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        TextFormField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.black),
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }
}
