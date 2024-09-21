import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentDetailsScreen extends StatefulWidget {
  final String userId;

  PaymentDetailsScreen({required this.userId});

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isBankDetails = true;
  bool _bankDetailsEntered = false;
  bool _upiDetailsEntered = false;
  bool _isLoading = false;
  final TextEditingController _accountHolderNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();
  Map<String, dynamic>? _bankDetails;
  String? _upiId;

  @override
  void initState() {
    super.initState();
    _fetchPaymentDetails();
  }

  Future<void> _fetchPaymentDetails() async {
    try {
      final bankDetailsResponse = await http.get(Uri.parse('http://192.168.42.125:3000/user/${widget.userId}/bank-details'));
      final upiDetailsResponse = await http.get(Uri.parse('http://192.168.42.125:3000/user/${widget.userId}/upi-details'));

      if (bankDetailsResponse.statusCode == 200) {
        setState(() {
          _bankDetails = jsonDecode(bankDetailsResponse.body);
          if (_bankDetails != null) {
            _accountHolderNameController.text = _bankDetails!['accountHolderName'];
            _accountNumberController.text = _bankDetails!['accountNumber'];
            _ifscCodeController.text = _bankDetails!['ifscCode'];
            _bankDetailsEntered = true;
          }
        });
      }

      if (upiDetailsResponse.statusCode == 200) {
        setState(() {
          _upiId = jsonDecode(upiDetailsResponse.body)['upiId'];
          if (_upiId != null) {
            _upiIdController.text = _upiId!;
            _upiDetailsEntered = true;
          }
        });
      }
    } catch (e) {
      print('Error fetching payment details: $e');
    }
  }

  Future<void> _saveBankDetails() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      Uri.parse('http://192.168.42.125:3000/user/${widget.userId}/bank-details'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'accountHolderName': _accountHolderNameController.text,
        'accountNumber': _accountNumberController.text,
        'ifscCode': _ifscCodeController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        _bankDetailsEntered = true; // Mark bank details as entered
      });
      _showAlert('Bank Details Updated', 'Bank details have been updated successfully.');
    } else {
      _showAlert('Error', 'Failed to update bank details. Please try again later.');
    }
  }

  Future<void> _saveUpiDetails() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      Uri.parse('http://192.168.42.125:3000/user/${widget.userId}/upi-details'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'upiId': _upiIdController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        _upiDetailsEntered = true; // Mark UPI ID as entered
      });
      _showAlert('UPI ID Updated', 'UPI ID has been updated successfully.');
    } else {
      _showAlert('Error', 'Failed to update UPI ID. Please try again later.');
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white24],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Set scaffold background to transparent
        appBar: AppBar(
          title: Text('Payment Details'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SwitchListTile(
                  title: Text('Use Bank Details'),
                  value: _isBankDetails,
                  onChanged: _bankDetailsEntered ? null : (bool value) {
                    setState(() {
                      _isBankDetails = value;
                    });
                  },
                ),
                if (_isBankDetails)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _accountHolderNameController,
                        decoration: InputDecoration(labelText: 'Account Holder Name'),
                        enabled: !_bankDetailsEntered,
                      ),
                      TextFormField(
                        controller: _accountNumberController,
                        decoration: InputDecoration(labelText: 'Account Number'),
                        enabled: !_bankDetailsEntered,
                      ),
                      TextFormField(
                        controller: _ifscCodeController,
                        decoration: InputDecoration(labelText: 'IFSC Code'),
                        enabled: !_bankDetailsEntered,
                      ),
                    ],
                  ),
                if (!_isBankDetails)
                  TextFormField(
                    controller: _upiIdController,
                    decoration: InputDecoration(labelText: 'UPI ID'),
                    enabled: !_upiDetailsEntered,
                  ),
                SizedBox(height: 16.0),
                if (_bankDetails != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Bank Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Account Holder Name: ${_bankDetails!['accountHolderName']}'),
                      Text('Account Number: ${_bankDetails!['accountNumber']}'),
                      Text('IFSC Code: ${_bankDetails!['ifscCode']}'),
                      SizedBox(height: 16.0),
                    ],
                  ),
                if (_upiId != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current UPI ID:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('UPI ID: $_upiId'),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_isBankDetails) {
                        if (!_bankDetailsEntered) {
                          _saveBankDetails();
                        } else {
                          _showAlert('No Changes', 'Bank details have already been entered and cannot be modified.');
                        }
                      } else {
                        if (!_upiDetailsEntered) {
                          _saveUpiDetails();
                        } else {
                          _showAlert('No Changes', 'UPI ID has already been entered and cannot be modified.');
                        }
                      }
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
