import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  final String userId;
  final String questionId;

  QuizScreen({required this.userId, required this.questionId});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  bool isLoading = true;
  bool isSubmitting = false;
  String message = '';
  int walletBalance = 0;
  int questionsAnswered = 0;
  final int dailyLimit = 10;

  @override
  void initState() {
    super.initState();
    checkDailyLimit();
    fetchQuestions();
  }

  Future<void> checkDailyLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedQuestionsAnswered = prefs.getInt('questionsAnswered') ?? 0;
    int storedCurrentQuestionIndex = prefs.getInt('currentQuestionIndex') ?? 0;
    setState(() {
      questionsAnswered = storedQuestionsAnswered;
      currentQuestionIndex = storedCurrentQuestionIndex;
    });
  }

  Future<void> fetchQuestions() async {
    try {
      var response = await http.get(Uri.parse('http://192.168.42.125:3000/api/questions'));
      if (response.statusCode == 200) {
        setState(() {
          questions = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          message = 'Failed to load questions';
        });
      }
    } catch (err) {
      setState(() {
        isLoading = false;
        message = 'Network error: $err';
      });
    }
  }

  Future<void> submitAnswer(String answer) async {
    if (isSubmitting || questionsAnswered >= dailyLimit) return;

    setState(() {
      isSubmitting = true;
      message = '';
    });

    try {
      var response = await http.post(
        Uri.parse('http://192.168.42.125:3000/api/answer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': widget.userId,
          'questionId': questions[currentQuestionIndex]['_id'],
          'answer': answer,
        }),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          message = responseData['message'];
          if (responseData['message'] == 'Answer correct. Wallet updated.') {
            walletBalance += 1;
          }
          questionsAnswered++;
          currentQuestionIndex++;
          isSubmitting = false;
          saveProgress();
        });
      } else {
        setState(() {
          isSubmitting = false;
          message = 'Failed to submit answer';
        });
      }
    } catch (err) {
      setState(() {
        isSubmitting = false;
        message = 'Network error: $err';
      });
    }
  }

  Future<void> saveProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('questionsAnswered', questionsAnswered);
    prefs.setInt('currentQuestionIndex', currentQuestionIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.black45],
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (questionsAnswered >= dailyLimit)
                Center(
                  child: Text('You have completed your daily quiz limit.'),
                )
              else ...[
                Text(
                  'Question ${currentQuestionIndex + 1}: ${questions[currentQuestionIndex]['question']}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                for (var option in questions[currentQuestionIndex]['options'])
                  ElevatedButton(
                    onPressed: isSubmitting ? null : () => submitAnswer(option),
                    child: Text(option),
                  ),
                if (isSubmitting) CircularProgressIndicator(),
                if (message.isNotEmpty) Text(message, style: TextStyle(color: Colors.red)),
              ],
              SizedBox(height: 20),
              Text('Wallet Balance: $walletBalance rupees'),
            ],
          ),
        ),
      ),
    );
  }
}
