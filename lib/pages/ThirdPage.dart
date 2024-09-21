import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:potoo/UserProvider.dart';
import 'package:provider/provider.dart';

class ThirdPage extends StatefulWidget {
  final String userId;

  ThirdPage({required this.userId});

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  TextEditingController withdrawalController = TextEditingController();
  List<dynamic> withdrawalHistory = [];
  bool isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    fetchWithdrawalHistory();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.get(Uri.parse('http://192.168.42.125:3000/user/${widget.userId}'));

    if (response.statusCode == 200) {
      final userDetails = jsonDecode(response.body);
      userProvider.setUserDetails(userDetails);
    }
  }

  Future<void> submitWithdrawal(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;
    final amount = withdrawalController.text.trim();

    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter an amount'),
      ));
      return;
    }

    setState(() {
      isLoading = true; // Set loading state to true
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.42.125:3000/user/${widget.userId}/withdraw'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': userId,
          'amount': double.parse(amount),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Withdrawal request submitted successfully'),
        ));
        await fetchUserDetails(); // Fetch updated user details to reflect new balance
        await fetchWithdrawalHistory(); // Fetch updated withdrawal history
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to submit withdrawal request'),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false
      });
    }
  }

  Future<void> fetchWithdrawalHistory() async {
    try {
      setState(() {
        isLoading = true;
      });

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

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.black45],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.black26,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 6,20,5),
                        alignment: Alignment.bottomRight,
                       child:  CircleAvatar(
                          radius:44,
                          backgroundImage: AssetImage('assets/logo.jpg'), // Provide your image path here
                        ),
                      ),
                      SizedBox(height: 20),
                      // Wallet Balance
                      Text(
                        'Wallet Balance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${userDetails['walletBalance']}', // Example balance
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // TextField for withdrawal amount
              TextField(
                controller: withdrawalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: '₹',
                  hintText: 'Amount',
                  labelText: 'Enter Amount to Withdraw',
                ),
              ),
              SizedBox(height: 20),
              // Withdrawal button
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () => submitWithdrawal(context),
                child: Text('Withdraw'),
              ),
              SizedBox(height: 20),
              // Withdrawal history list
              withdrawalHistory.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
            ],
          ),
        ),
      ),
    );
  }
}
