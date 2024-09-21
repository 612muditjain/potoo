// lib/models/question.dart
class Question {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
    );
  }
}

// answer_request.dart

class AnswerRequest {
  final String userId;
  final String questionId;
  final String answer;

  AnswerRequest({required this.userId, required this.questionId, required this.answer});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'questionId': questionId,
      'answer': answer,
    };
  }
}
