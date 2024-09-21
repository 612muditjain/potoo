// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:potoo/Question/question.dart';
// import 'dart:convert';
//
// import 'package:potoo/pages/SecondPage2.dart';
//
// class ApiServicesQuestion {
//   Future<void> submitAnswer(BuildContext context, String userId, String questionId, String answer) async {
//     final url = Uri.parse('http://192.168.210.125:3000/api/answer');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'userId': userId, 'questionId': questionId, 'answer': answer}),
//     );
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//       final String message = responseData['message'];
//       final dynamic nextQuestionData = responseData['nextQuestion'];
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//
//       if (nextQuestionData != null) {
//         final Question nextQuestion = Question.fromJson(nextQuestionData);
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => QuizScreen(questionId: questionId)),
//         );
//       } else {
//         // Handle no more questions case
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No more questions.')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to submit answer.')),
//       );
//     }
//   }
// }
