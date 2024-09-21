import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RatGamePage extends StatefulWidget {
  final String userId;

  RatGamePage({required this.userId});

  @override
  _RatGamePageState createState() => _RatGamePageState();
}

class _RatGamePageState extends State<RatGamePage> {
  String username = '';
  int totalPoints = 0;
  int dailyCoinsCollected = 0;
  double walletBalance = 0.0;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      var response = await http.get(
        Uri.parse('http://192.168.42.125:3000/user/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var userDetails = jsonDecode(response.body);
        setState(() {
          username = userDetails['username'] ?? 'User';
          totalPoints = userDetails['totalPoints'] ?? 0;
          dailyCoinsCollected = userDetails['dailyCoinsCollected'] ?? 0;
          walletBalance = (userDetails['walletBalance'] ?? 0).toDouble();
        });
      } else {
        print('Failed to load user details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading user details: $error');
    }
  }

  Future<void> collectCoins(int coins) async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.42.125:3000/collect-coins'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': widget.userId, 'points': coins}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          totalPoints += coins;  // Add the collected points to the total points
          dailyCoinsCollected += coins;  // Add the collected points to the daily coins collected
        });
        print('Coins collected successfully.');
        await fetchUserDetails();
      } else {
        print('Failed to collect coins: ${response.statusCode}');
      }
    } catch (error) {
      print('Error collecting coins: $error');
    }
  }

  Future<void> convertCoins() async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.42.125:3000/convert-coins'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': widget.userId}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          walletBalance = (data['walletBalance'] ?? 0).toDouble();
          totalPoints = 0;
        });
        print('Coins converted successfully.');
        await fetchUserDetails();
      } else {
        print('Failed to convert coins: ${response.statusCode}');
      }
    } catch (error) {
      print('Error converting coins: $error');
    }
  }

  void showLimitReachedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Daily coin limit reached!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rat Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Username: $username',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                if (dailyCoinsCollected < 300) {
                  await collectCoins(2);  // Collect 2 points on image click
                  await fetchUserDetails();
                } else {
                  showLimitReachedMessage();
                }
              },
              child: ClipOval(
                child: Image.asset('assets/logo.jpg', width: 200, height: 200, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Daily Coins Collected: $dailyCoinsCollected',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Total Points: $totalPoints',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Wallet Balance: $walletBalance',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: totalPoints >= 100 ? () async {
                await convertCoins();
                await fetchUserDetails();
              } : null,
              child: Text('Convert'),
            ),
          ],
        ),
      ),
    );
  }
}
