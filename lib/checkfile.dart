import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:potoo/UserProvider.dart';
import 'package:provider/provider.dart';

class WithdrawalHistoryScreen extends StatefulWidget {
  final String userId;

  WithdrawalHistoryScreen({required this.userId});

  @override
  _WithdrawalHistoryScreenState createState() => _WithdrawalHistoryScreenState();
}

class _WithdrawalHistoryScreenState extends State<WithdrawalHistoryScreen> {
  List<dynamic> withdrawalHistory = [];

  @override
  void initState() {
    super.initState();
    fetchWithdrawalHistory();
  }

  Future<void> fetchWithdrawalHistory() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdrawal History'),
      ),
      body: withdrawalHistory.isNotEmpty
          ? ListView.builder(
        itemCount: withdrawalHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Amount: ₹${withdrawalHistory[index]['amount']}'),
            subtitle: Text('Status: ${withdrawalHistory[index]['status']}'),
            trailing: Text('Date: ${withdrawalHistory[index]['createdAt']}'),
          );
        },
      )
          : Center(
        child: Text('No withdrawal history found'),
      ),
    );
  }
}
