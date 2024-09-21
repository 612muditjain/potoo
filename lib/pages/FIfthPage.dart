import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:potoo/drawerscreen/settingscreen.dart';
import 'package:potoo/SettingScreen/userscreen.dart';
import 'package:potoo/SettingScreen/walletscreen.dart';

class FifthPage extends StatefulWidget {
  final String userId;

  FifthPage({required this.userId});

  @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  String name = '';
  String email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final Uri uri = Uri.parse('http://192.168.42.125:3000/user/${widget.userId}');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final userDetails = jsonDecode(response.body);
        setState(() {
          name = userDetails['username'];
          email = userDetails['email'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user details')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateUserProfile(BuildContext context, String userId, String name, String mobileNumber, String email) async {
    final Uri uri = Uri.parse('http://192.168.42.125:3000/user/$userId');

    try {
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': name,
          'mobileNumber': mobileNumber,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        fetchUserDetails(); // Fetch updated user details after updating profile
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  void _showUpdateProfileDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: name);
    final TextEditingController mobileNumberController = TextEditingController();
    final TextEditingController emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Profile Info', style: TextStyle(fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: mobileNumberController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
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
                String newName = nameController.text.trim();
                String newMobileNumber = mobileNumberController.text.trim();
                String newEmail = emailController.text.trim();

                if (newName.isNotEmpty && newMobileNumber.isNotEmpty && newEmail.isNotEmpty) {
                  updateUserProfile(context, widget.userId, newName, newMobileNumber, newEmail); // Pass context here
                  Navigator.of(context).pop(); // Close dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/logo.jpg'), // Provide your image path here
            ),
            SizedBox(height: 15),
            Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showUpdateProfileDialog(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
              ),
              child: Text('Update Profile'),
            ),
            SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(24, 5, 24, 5),
              tileColor: Colors.transparent,
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(24, 5, 24, 5),
              tileColor: Colors.transparent,
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    'Wallet',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentDetailsScreen(userId: widget.userId)));
              },
            ),
            SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(24, 5, 24, 5),
              tileColor: Colors.transparent,
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.person_outline_sharp,
                  color: Colors.white,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    'User',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserScreen()));
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(24, 5, 24, 5),
              tileColor: Colors.transparent,
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    'Information',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                // Navigate to information screen
              },
            ),
            SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(24, 5, 24, 5),
              tileColor: Colors.transparent,
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.exit_to_app_sharp,
                  color: Colors.white,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                // Navigate to logout screen or perform logout action
              },
            ),
          ],
        ),
      ),
    );
  }
}
