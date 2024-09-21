import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:potoo/screens/NewPasswordScreen.dart';
import 'package:potoo/screens/loginscreen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _otpController = TextEditingController();

  Future<void> verifyOTP() async {
    final Uri uri = Uri.parse('http://192.168.42.125:3000/api/verifyOTP'); // Replace with your backend URL
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'otp': _otpController.text,
          'phoneNumber': widget.phoneNumber, // Pass the phone number for verification
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResetPasswordScreen(phoneNumber: widget.phoneNumber,)),
        );
      } else {
        // Handle OTP verification failure
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('OTP Verification Failed'),
            content: Text('Invalid OTP. Please try again.'),
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
      print('Error verifying OTP: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to verify OTP. Please try again later.'),
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

  Future<void> resendOTP() async {
    final Uri uri = Uri.parse('http://192.168.42.125:3000/api/resend-otp'); // Replace with your backend URL
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'phoneNumber': widget.phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP resent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resend OTP')),
        );
      }
    } catch (error) {
      print('Error resending OTP: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend OTP. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
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
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifyOTP,
                child: Text('Verify OTP'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: resendOTP,
                child: Text('Resend OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
