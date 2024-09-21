import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Paris', 'London', 'Berlin', 'Rome'],
      'correctAnswer': 'Paris',
    },
    {
      'question': 'Who wrote "Romeo and Juliet"?',
      'options': ['William Shakespeare', 'Charles Dickens', 'Jane Austen', 'Leo Tolstoy'],
      'correctAnswer': 'William Shakespeare',
    },
  ];

  void _checkAnswer(String selectedOption) {
    String correctAnswer = _questions[_currentIndex]['correctAnswer'];
    if (selectedOption == correctAnswer) {
      setState(() {
        _score++;
      });
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
      } else {
        // Quiz finished, show score or result screen
        _showResultScreen();
      }
    });
  }

  void _showResultScreen() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Finished'),
        content: Text('Your score: $_score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Reset quiz
              setState(() {
                _currentIndex = 0;
                _score = 0;
              });
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _questions[_currentIndex]['question'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...(_questions[_currentIndex]['options'] as List<String>).map((option) {
              return ElevatedButton(
                onPressed: () {
                  _checkAnswer(option);
                },
                child: Text(option),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
