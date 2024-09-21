import 'package:flutter/material.dart';
import 'package:potoo/UserProvider.dart';
import 'package:provider/provider.dart';

import '../screens/homescreen.dart';

class TermsConditionScreen extends StatelessWidget {
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
        title: Text('Terms and Conditions'),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Welcome to our MLM Application. These terms and conditions outline the rules and regulations for the use of our application.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '1. Acceptance of Terms',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'By accessing or using our MLM Application, you agree to be bound by these terms and conditions. If you do not agree to all the terms and conditions, then you may not access the application.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '2. Membership',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'a. To become a member of our MLM Application, you must be at least 18 years old and able to enter into legally binding contracts.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'b. You must provide accurate and complete information during the registration process.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '3. Prohibited Activities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'a. You are prohibited from using our MLM Application for any unlawful purpose or activity.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'b. You may not engage in any activity that disrupts or interferes with the operation of the application.',
                style: TextStyle(fontSize: 16),
              ),
              // Add more rules as needed
            ],
          ),
        ),
      ),
      ),
    );
  }
}
