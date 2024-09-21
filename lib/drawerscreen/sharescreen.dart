import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

import '../UserProvider.dart';
import '../screens/homescreen.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();


  void _sendReferral(String referralCode) async {
    String name = _nameController.text;
    String email = _emailController.text;
    String mobile = _mobileNumberController.text;

    // Construct referral message
    String referralMessage =
        'Hello $name,\n\nI invite you to join using my referral code $referralCode and get exclusive offers!\n\nRegards,\nYour Friend';

    try {
      // Launch WhatsApp with the referral message
      String whatsappUrl = "whatsapp://send?phone=$mobile&text=${Uri.parse(referralMessage)}";
      if (await canLaunch(whatsappUrl)) {

        final byteData = await rootBundle.load('assets/logo.jpg');
        final Uint8List bytes = byteData.buffer.asUint8List();

        // Get the temporary directory to store the app logo file
        final tempDir = await getTemporaryDirectory();
        final File file = File('${tempDir.path}/logo.jpg');
        await file.writeAsBytes(bytes);

        // Share the text and the app logo via WhatsApp
        await Share.shareFiles([file.path], text: whatsappUrl);


        await launch(whatsappUrl);
      } else {
        throw 'Could not launch WhatsApp';
      }

    } catch (e) {
      print('Error launching WhatsApp: $e');
      // Handle error launching WhatsApp
    }
  }

  Future<void> shareReferralLink(String url, String referralCode, String username) async {
    final shareText = 'Hello $username,\n\nJoin us using my referral code $referralCode and get exclusive offers! $url';

    try {
      // Load the app logo from assets
      final byteData = await rootBundle.load('assets/logo.jpg');
      final Uint8List bytes = byteData.buffer.asUint8List();

      // Get the temporary directory to store the app logo file
      final tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/logo.jpg');
      await file.writeAsBytes(bytes);

      // Share the text and the app logo via other apps
      await Share.shareFiles([file.path], text: shareText);
    } catch (e) {
      print('Error sharing link: $e');
      // Show an error message to the user
    }
  }


  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserProvider>(context).userDetails;
    final referralCode = userDetails['referralCode']; // Assuming referral code is part of userDetails
    final username = userDetails['username']; // Assuming username is part of userDetails

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
        title: Text('Refer a Friend'),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your friend\'s name :',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Enter your friend\'s email:',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Enter your friend\'s Mobile Number:',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
                controller: _mobileNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Mobile Number',
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _sendReferral(referralCode),
              child: Text('Send Referral via WhatsApp'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await shareReferralLink('https://example.com', referralCode, username);
              },
              child: Text('Share Referral Link'),
            ),
            SizedBox(height: 20),
            Text(
              'Your Referral Code: $referralCode',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),),
    );
  }
}
