import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:potoo/screens/OtpScreen.dart';
import 'package:potoo/screens/loginscreen.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false; // Add loading state

  Future<void> sendOTP(String phoneNumber) async {
    final Uri uri = Uri.parse('http://192.168.42.125:3000/api/sendOTP');

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phoneNumber': phoneNumber,
        }),
      );

      setState(() {
        _isLoading = false; // Stop loading
      });

      if (response.statusCode == 200) {
        // OTP sent successfully, navigate to OTP screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(phoneNumber: phoneNumber),
          ),
        );
      } else {
        // Handle OTP sending failure
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('OTP Sending Failed'),
            content: Text('Failed to send OTP. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false; // Stop loading
      });

      // Handle HTTP request errors
      print('Error sending OTP: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to connect to server. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
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
                'Forgot Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20.0),
              _isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : ElevatedButton(
                onPressed: () {
                  String phoneNumber = '+91' + _phoneNumberController.text.trim();
                  if (phoneNumber.isNotEmpty) {
                    sendOTP(phoneNumber);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Phone Number Required'),
                        content: Text('Please enter a valid phone number.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
