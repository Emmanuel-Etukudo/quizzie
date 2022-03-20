import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quizzie/controllers/quiz/quiz_controller.dart';
import 'package:quizzie/controllers/quiz/quiz_state.dart';
import 'package:quizzie/models/question_models.dart';
import 'package:quizzie/repositories/quiz/quiz_repository.dart';
import 'package:quizzie/ui/quiz_screen.dart';

class QuizResults extends ConsumerWidget {
  final QuizState state;
  final List<Question> questions;
  const QuizResults({
    Key? key,
    required this.state,
    required this.questions
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${state.correct.length} / ${questions.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60.0,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const Text(
          'CORRECT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40.0,
            fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40.0,),
        CustomButton(title: "Start New Quiz", onTap: (){
          ref.refresh(quizRepositoryProvider);
          ref.read(quizControllerProvider.notifier).reset();
        })
      ],
    );
  }
}
