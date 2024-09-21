import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:potoo/SettingScreen/changeaccountscreen.dart';
import 'package:potoo/SettingScreen/privacypolicyscreen.dart';
import 'package:potoo/UserProvider.dart';
import 'package:potoo/screens/homescreen.dart';
import 'package:potoo/SettingScreen/termsandcondition.dart';

class SettingsScreen extends StatelessWidget {

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
        backgroundColor: Colors.black45,
        titleTextStyle: TextStyle(color: Colors.white,fontSize: 18),
        title: Text('Setting'),
      ),
    body: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Colors.black45], // Adjust colors as needed
      ),
    ),
    child:ListView(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(24, 5, 24, 5),
            tileColor: Colors.transparent, // Set tile color to transparent
            leading: Container(
              child: Icon(
                Icons.person_outline_sharp,
                color: Colors.blue, // Change color of setting icon
              ),
            ),
            title: Row(
              children: [
                Text(
                  'Account',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold// Change text color
                  ),
                ),
              ],
            ),
            onTap: () {
              // Navigate to settings screen
            },
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(24, 5, 24, 5),
            tileColor: Colors.transparent, // Set tile color to transparent
            title: Row(
              children: [
                Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.black, // Change text color
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue, // Change background color of trailing container
                borderRadius: BorderRadius.circular(25), // Add rounded corners
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white, // Change color of trailing icon
              ),
            ),
            onTap: () {
              // Navigate to settings screen
              _showPasswordChangeDialog(context);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(24, 5, 24, 5),
            tileColor: Colors.transparent, // Set tile color to transparent
            title: Row(
              children: [
                Text(
                  'Change Social Account',
                  style: TextStyle(
                    color: Colors.black, // Change text color
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue, // Change background color of trailing container
                borderRadius: BorderRadius.circular(25), // Add rounded corners
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white, // Change color of trailing icon
              ),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>SocialAccountScreen()
              ));// Navigate back when button is pressed
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(24, 5, 24, 5),
            tileColor: Colors.transparent, // Set tile color to transparent
            title: Row(
              children: [
                Text(
                  'Privacy and Policy',
                  style: TextStyle(
                    color: Colors.black, // Change text color
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue, // Change background color of trailing container
                borderRadius: BorderRadius.circular(25), // Add rounded corners
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white, // Change color of trailing icon
              ),
            ),
            onTap: () {
              // Navigate to settings screen
              Navigator.push(context, MaterialPageRoute(builder: (context) =>PrivacyPolicyScreen()));// Navigate back when button is pressed
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(24, 5, 24, 5),
            tileColor: Colors.transparent, // Set tile color to transparent
            title: Row(
              children: [
                Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    color: Colors.black, // Change text color
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue, // Change background color of trailing container
                borderRadius: BorderRadius.circular(25), // Add rounded corners
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white, // Change color of trailing icon
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>TermsConditionScreen()));// Navigate back when button is pressed
              // Navigate to settings screen
            },
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(24, 5, 24, 5),
            tileColor: Colors.transparent, // Set tile color to transparent
            leading: Container(
              child: Icon(
                Icons.volume_up_sharp,
                color: Colors.blue, // Change color of setting icon
              ),
            ),
            title: Row(
              children: [
                Text(
                  'Notification',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold// Change text color
                  ),
                ),
              ],
            ),
            onTap: () {
              // Navigate to settings screen
            },
          ),
        ],
      ),
    ),
    ),
    );
  }
}

void _showPasswordChangeDialog(BuildContext context) {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: oldPasswordController,
              decoration: InputDecoration(labelText: 'Old Password'),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Update'),
            onPressed: () {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('New passwords do not match'),
                ));
              } else {
                _changePassword(
                  context,
                  oldPasswordController.text,
                  newPasswordController.text,
                );
              }
            },
          ),
        ],
      );
    },
  );
}

void _changePassword(BuildContext context, String oldPassword, String newPassword) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final userId = userProvider.userDetails;

  final url = 'http://192.168.42.125:3000/change-password'; // Update with your backend URL
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': userId,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    }),
  );

  if (response.statusCode == 200) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Password updated successfully'),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to update password'),
    ));
  }
}
