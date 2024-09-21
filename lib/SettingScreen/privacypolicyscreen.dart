import 'package:flutter/material.dart';
import 'package:potoo/UserProvider.dart';
import 'package:provider/provider.dart';

import '../screens/homescreen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserProvider>(context).userDetails;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userDetails: userDetails)),
        );
        return true; // Return true to allow back navigation
      },
      child:Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        titleTextStyle: TextStyle(color: Colors.white,fontSize: 18),
        title: Text('Privacy Policy'),
      ),
      body:Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.black45], // Adjust colors as needed
          ),
        ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'This is the privacy policy of our MLM application. We respect your privacy and are committed to protecting it. This Privacy Policy describes our policies and procedures on the collection, use, and disclosure of your information when you use the application.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Terms of Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'By using our MLM application, you agree to be bound by these terms of service. Please read these terms carefully before using our application. If you do not agree to these terms, please do not use our application.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Example Terms & Conditions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '1. You must be at least 18 years old to use this application.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '2. You agree not to distribute any content that violates the rights of others.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '3. We reserve the right to suspend or terminate your access to the application at any time for any reason.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '1. Introduction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Our MLM application ("the App") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and disclose personal information when you use our App.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '2. What Information We Collect',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'a. Personal Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '- Name, email address, phone number, address, payment information, etc.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'b. Usage Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '- Interaction data, device information, logs, cookies, etc.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '3. How We Use Your Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- To provide and maintain the App, to notify you about changes, and to improve our services.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- To provide customer support and respond to inquiries.',
              style: TextStyle(fontSize: 16),
            ),
            // Add more terms and conditions as needed
          ],
        ),
      ),
      ),
      ),
    );
  }
}
