import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:potoo/screens/forgotpassword.dart';
import 'package:potoo/verify_otp.dart'; // Ensure correct import path

import 'package:potoo/screens/homescreen.dart';
import 'package:provider/provider.dart';
import '../UserProvider.dart';
import 'loginscreen.dart'; // Import your HomeScreen or destination screen

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  String _selectedPlan = 'Gold'; // Default plan
  List<String> _plans = ['Gold', 'Silver', 'Platinum']; // List of available plans
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation
  bool _isLoading = false; // Track loading state

  // Regular expression for password validation: minimum 8 characters, mix of letters, numbers, and special characters
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[a-zA-Z])(?=.*[0-9!@#$%^&*+=?-_]).{8,}$',
  );

  // Email validation function
  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }
    // Email regex validation
    bool isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
    if (!isValid) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Password validation function
  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (!_passwordRegExp.hasMatch(value)) {
      return 'Password must be at least 8 characters long and include letters, numbers, and special characters';
    }
    return null;
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true; // Start loading indicator
    });

    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String phoneNumber = '+91' + _phoneNumberController.text; // Prefix with +91
    final String password = _passwordController.text;
    final String referralCode = _referralCodeController.text.isNotEmpty
        ? _referralCodeController.text
        : '83898'; // Use default referral code if empty
    final String plan = _selectedPlan; // Use selected plan

    // Replace with your API URL
    final url = Uri.parse('http://192.168.42.125:3000/signup');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
          'referralCode': referralCode,
          'plan': plan,
        }),
      );

      if (response.statusCode == 201) {
        // Signup successful, navigate to VerifyOtpPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpPage(
              phoneNumber: phoneNumber,
              onVerificationSuccess: () {
                final userDetails = Provider.of<UserProvider>(context).userDetails;

                // After OTP verification success, navigate to HomeScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(userDetails: userDetails),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        // Signup failed, show error message
        final Map<String, dynamic> responseBody = json.decode(response.body);
        print('Failed to signup: ${responseBody['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${responseBody['message']}')),
        );
      }
    } catch (e) {
      print('Error during signup: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during signup. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Potoo'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.black45], // Adjust colors as needed
          ),
        ),
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(), // Display circular progress indicator while loading
        )
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // Form key assigned here
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      String? emailError = _validateEmail(value!);
                      if (emailError != null) {
                        return emailError;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone, // Ensure it's a phone number input
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      String? passwordError = _validatePassword(value!);
                      if (passwordError != null) {
                        return passwordError;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _referralCodeController,
                    decoration: InputDecoration(
                      labelText: 'Referral Code (optional)',
                      border: OutlineInputBorder(),
                      hintText: '83898',
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedPlan,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedPlan = newValue!;
                      });
                    },
                    items: _plans.map((plan) {
                      return DropdownMenuItem<String>(
                        value: plan,
                        child: Text(plan),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Plan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signup,
                    child: Text('Sign Up'),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Navigate to your Forgot Password page or screen
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotScreen()));
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navigate to your login page or destination
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
