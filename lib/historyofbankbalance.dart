import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:potoo/UserProvider.dart'; // Replace with your provider import
import 'package:potoo/screens/homescreen.dart';
import 'package:provider/provider.dart';

class WalletHistory extends StatefulWidget {
  final String userId;

  WalletHistory({required this.userId});

  @override
  _WalletHistoryState createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  List<dynamic> withdrawalHistory = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWithdrawalHistory();
  }

  Future<void> fetchWithdrawalHistory() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.42.125:3000/withdraw/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> withdrawals = jsonDecode(response.body);
        setState(() {
          withdrawalHistory = withdrawals;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch withdrawal history'),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
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
    child:Scaffold(
      appBar: AppBar(
        title: Text('Withdrawal History'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : withdrawalHistory.isNotEmpty
          ? ListView.builder(
        itemCount: withdrawalHistory.length,
        itemBuilder: (context, index) {
          final withdrawal = withdrawalHistory[index];
          return ListTile(
            title: Text('Amount: ₹${withdrawal['amount']}'),
            subtitle: Text('Status: ${withdrawal['status']}'),
            trailing: Text('Date: ${withdrawal['createdAt']}'),
          );
        },
      )
          : Center(
        child: Text('No withdrawal history found'),
      ),
    ),

    );
  }
}
