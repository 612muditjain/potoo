import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../UserProvider.dart';
import '../screens/homescreen.dart';

class NotificationScreen extends StatefulWidget {
  final String userId;
  final int level;

  NotificationScreen({required this.userId, required this.level});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> referrals = [];

  @override
  void initState() {
    super.initState();
    fetchReferrals();
  }

  Future<void> fetchReferrals() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.42.125:3000/referrals/${widget.userId}/${widget.level}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          referrals = List<Map<String, dynamic>>.from(data['referrals']);
        });
      } else {
        // Handle error
        print('Failed to load referrals: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network error
      print('Error fetching referrals: $error');
    }
  }

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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
          title: Text('Notifications'),
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Add back button icon
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(userDetails: userDetails)),
              ); // Navigate back when button is pressed
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.black45],
            ),
          ),
          child: ListView.builder(
            itemCount: referrals.length,
            itemBuilder: (context, index) {
              final referral = referrals[index];
              return ListTile(
                title: Text(referral['username']),
                subtitle: Text(referral['email']),
                // Add more details as needed
                leading: Icon(Icons.person), // You can replace this with your image widget
                trailing: Icon(Icons.arrow_forward),
              );
            },
          ),
        ),
      ),
    );
  }
}
