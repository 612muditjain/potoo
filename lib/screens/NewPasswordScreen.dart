import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordScreen extends StatefulWidget {
  final String phoneNumber;
  const ResetPasswordScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}



class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      // final String phoneNumber = _phoneNumberController.text;
      // TextEditingController _phoneNumberController = TextEditingController();

      final String newPassword = _newPasswordController.text;

      final url = Uri.parse('http://192.168.42.125:3000/api/resetPassword');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phoneNumber': widget.phoneNumber, 'newPassword': newPassword}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully')),
        );
        // Navigate to the login screen or home screen
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update password')),
        );
      }
    }
  }
  // @override
  // void initState() {
  //   super.initState();
  //   // Add +91 prefix by default
  //   _phoneNumberController.text = '+91';
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Container(
          width: MediaQuery.of(context).size.width,
           height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.black45],
        ),
    ),child:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // TextFormField(
              //   controller: _phoneNumberController,
              //   decoration: InputDecoration(labelText: 'Phone Number',  border: OutlineInputBorder(),),
              //   keyboardType: TextInputType.phone,
              //
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter your phone number';
              //     }
              //     if (!value.startsWith('+91')) {
              //       return 'Phone number must start with +91';
              //     }
              //     if (value.length != 13) { // +91 and 10 digit number
              //       return 'Please enter a valid phone number';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'New Password',  border: OutlineInputBorder(),),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password',  border: OutlineInputBorder(),),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
