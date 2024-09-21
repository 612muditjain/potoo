import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:potoo/screens/homescreen.dart';
import 'package:provider/provider.dart';
import 'UserProvider.dart'; // Import your UserProvider

class VerifyOtpPage extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onVerificationSuccess; // Add this line


  VerifyOtpPage({required this.phoneNumber, required this.onVerificationSuccess});

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController _otpController = TextEditingController();

  Future<void> _verifyOtp() async {
    final String otp = _otpController.text;
    final String phoneNumber = widget.phoneNumber;

    final url = Uri.parse('http://192.168.42.125:3000/verify-number');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      // Get user details without listening for changes
      final userDetails = Provider.of<UserProvider>(context, listen: false).userDetails;

      // OTP verification successful, navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userDetails: userDetails)),
      );
    } else {
      // OTP verification failed, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
