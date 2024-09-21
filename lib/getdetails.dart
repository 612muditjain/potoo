import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDetailsScreen extends StatefulWidget {
  final String userId;

  UserDetailsScreen({required this.userId});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> referrals = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      var response = await http.get(Uri.parse('http://192.168.42.125:3000/user/${widget.userId}'));
      // var response = await http.get(Uri.parse('http://192.168.210.125:3000/user/66839824a94254a86356f241'));

      if (response.statusCode == 200) {
        userData = jsonDecode(response.body);
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load user details: ${response.statusCode}';
        });
        print('Failed to load user details: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Network error: $error';
      });
      print('Network error: $error');
    }
  }

  Future<void> fetchReferralData(int level) async {
    try {
      var response = await http.get(Uri.parse('http://192.168.42.125:3000/referrals/${widget.userId}/$level'));
      // var response = await http.get(Uri.parse('http://192.168.210.125:3000/referrals/66839824a94254a86356f241/$level'));

      if (response.statusCode == 200) {
        Map<String, dynamic> referralData = jsonDecode(response.body);
        setState(() {
          referrals = List<Map<String, dynamic>>.from(referralData['referrals']);
        });
      } else {
        print('Failed to load referral data: ${response.statusCode}');
      }
    } catch (error) {
      print('Network error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : userData != null
          ? ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: Text('Username: ${userData!['username']}'),
          ),
          ListTile(
            title: Text('Earnings: ${userData!['earnings']}'),
          ),
          for (int level = 1; level <= 7; level++) ...[
            ElevatedButton(
              onPressed: () async {
                await fetchReferralData(level); // Fetch referrals for the current level
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReferralDetailsScreen(referrals: referrals, level: level),
                  ),
                );
              },
              child: Text('View Level $level Referrals'),
            ),
          ],
        ],
      )
          : Center(child: Text('No user details available')),
    );
  }
}

class ReferralDetailsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> referrals;
  final int level;

  ReferralDetailsScreen({required this.referrals, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level $level Referral Details'),
      ),
      body: referrals.isNotEmpty
          ? ListView.builder(
        itemCount: referrals.length,
        itemBuilder: (context, index) {
          final referral = referrals[index];
          return ListTile(
            title: Text('Username: ${referral['username']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Earnings: ${referral['earnings']}'),
                Text('Plan: ${referral['plan']}'),
                // Add more referral details as needed
              ],
            ),
          );
        },
      )
          : Center(child: Text('No referrals available for this level')),
    );
  }
}
