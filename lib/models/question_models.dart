// To parse this JSON data, do
//
//     final quizzie = quizzieFromMap(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

Question quizzieFromMap(String str) => Question.fromMap(json.decode(str));

String quizzieToMap(Question data) => json.encode(data.toMap());

class Question extends Equatable{
  Question({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  factory Question.fromMap(Map<String, dynamic> json) {
    //if (json == null) return null;
    return Question(
    category: json["category"],
    type: json["type"],
    difficulty: json["difficulty"],
    question: json["question"],
    correctAnswer: json["correct_answer"],
    incorrectAnswers: List<String>.from(json["incorrect_answers"].map((x) => x)),
  );
  }

  Map<String, dynamic> toMap() => {
    "category": category,
    "type": type,
    "difficulty": difficulty,
    "question": question,
    "correct_answer": correctAnswer,
    "incorrect_answers": List<dynamic>.from(incorrectAnswers.map((x) => x)),
  };

  @override
  List<Object?> get props => [
    category,
    difficulty,
    question,
    correctAnswer,
    incorrectAnswers
  ];
}
