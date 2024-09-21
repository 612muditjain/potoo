import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic> _userDetails = {};

  Map<String, dynamic> get userDetails => _userDetails;
  String _userId = ''; // You might want to set this from user login
  int _walletBalance = 0;
  int _questionsAnsweredToday = 0;
  DateTime _lastLoginDate = DateTime.now();

  String get userId => _userId;
  int get walletBalance => _walletBalance;
  int get questionsAnsweredToday => _questionsAnsweredToday;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  void setWalletBalance(int balance) {
    _walletBalance = balance;
    notifyListeners();
  }

  void incrementQuestionsAnsweredToday() {
    _questionsAnsweredToday++;
    notifyListeners();
  }

  void resetQuestionsAnsweredToday() {
    _questionsAnsweredToday = 0;
    notifyListeners();
  }

  void checkAndResetDailyCount() {
    if (_lastLoginDate.day != DateTime.now().day) {
      resetQuestionsAnsweredToday();
      _lastLoginDate = DateTime.now();
    }
  }

  void setUserDetails(Map<String, dynamic> userDetails) {
    _userDetails = userDetails;
    notifyListeners();
  }
}
