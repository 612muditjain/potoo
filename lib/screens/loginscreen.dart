import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:potoo/screens/homescreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../UserProvider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    String emailOrPhone = _emailOrPhoneController.text.trim();
    final String password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://192.168.42.125:3000/login');

      final bool isEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailOrPhone);
      final bool isPhone = RegExp(r'^\d{10}$').hasMatch(emailOrPhone);

      final Map<String, dynamic> body;

      if (isEmail) {
        body = {'email': emailOrPhone, 'password': password};
      } else if (isPhone) {
        emailOrPhone = '+91$emailOrPhone';
        body = {'phoneNumber': emailOrPhone, 'password': password};
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Please enter a valid email or 10-digit phone number.');
        return;
      }

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String userId = responseBody['userId'];

        // Fetch user details
        final userDetails = await _getUserDetails(userId);

        // Save login state and user details in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userDetails', jsonEncode(userDetails));

        // Update UserProvider with user details
        Provider.of<UserProvider>(context, listen: false).setUserDetails(userDetails);

        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userDetails: userDetails),
          ),
        );
      } else if (response.statusCode == 400) {
        _showErrorDialog('User not found.');
      } else if (response.statusCode == 401) {
        _showErrorDialog('Password incorrect.');
      } else {
        _showErrorDialog('An error occurred. Please try again later.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('An error occurred. Please try again later.');
      print('Error during login: $e');
    }
  }

  Future<Map<String, dynamic>> _getUserDetails(String userId) async {
    final url = Uri.parse('http://192.168.42.125:3000/user/$userId');

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user details');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.pushNamed(context, '/forgotPassword');
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, '/SignUpPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Potoo'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.black45],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _emailOrPhoneController,
                decoration: InputDecoration(
                  labelText: 'Email or Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _navigateToForgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _navigateToSignUp,
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
