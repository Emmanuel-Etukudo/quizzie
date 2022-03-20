import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quizzie/controllers/quiz/quiz_controller.dart';
import 'package:quizzie/controllers/quiz/quiz_state.dart';
import 'package:quizzie/enums/difficulty.dart';
import 'package:quizzie/repositories/quiz/quiz_repository.dart';
import 'package:quizzie/ui/quiz_questions.dart';
import 'package:quizzie/ui/quiz_results.dart';

import '../models/question_models.dart';

final quizQuestionsProvider = FutureProvider.autoDispose<List<Question>>(
    (ref)=> ref.watch(quizRepositoryProvider).getQuestions(
        numQuestions: 10,
        categoryId: Random().nextInt(24) + 9,
        difficulty: Difficulty.any),
);

class QuizScreen extends HookConsumerWidget {
   const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Question>> quizQuestions = ref.watch(quizQuestionsProvider);
    final pageController = usePageController();

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xff5b247a), Color(0xff1bcedf)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: quizQuestions.when(
            data: (questions) => _buildBody(context, pageController, questions,ref),
            error: (error, _) => QuizError(message: '',),
            loading:() => const Center(child: CircularProgressIndicator(),),
        ),
        bottomSheet: quizQuestions.maybeWhen(
          data: (questions){
            final quizState = ref.read(quizControllerProvider);
            if (!quizState.answered) return const SizedBox.shrink();
            return CustomButton(
                title: pageController.page!.toInt() + 1 < questions.length
                ? 'Next Question'
                : 'See Results',
                onTap: (){
                  ref.
                  read(quizControllerProvider.notifier)
                      .nextQuestion(questions, pageController.page!.toInt());
                  if(pageController.page!.toInt() + 1 < questions.length){
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.linear
                    );
                  }
                });
          }, orElse: () => const SizedBox.shrink(),
        ),
      ),
      );
  }
}

Widget _buildBody(
    BuildContext context,
    PageController pageController,
    List<Question> questions,
    WidgetRef ref,
    ){
  if (questions.isEmpty) return QuizError(message: 'No questions found.');

  final quizState = ref.watch(quizControllerProvider);
  return quizState.status == QuizStatus.complete
      ? QuizResults(state: quizState, questions: questions,)
      : QuizQuestions(
          pageController: pageController,
          state: quizState,
          questions: questions,);

}

class QuizError extends ConsumerWidget {

  final String message;
  const QuizError({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0
            ),
          ),
          const SizedBox(height: 20,),
          CustomButton(
            title: 'Retry',
            onTap: () => ref.refresh(quizRepositoryProvider),
          )
        ],
      ),
    );
  }
}

const List<BoxShadow> boxShadow = [
  BoxShadow(
    color: Colors.black26,
    offset: Offset(0, 2),
    blurRadius: 4.0,
  )
];

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const CustomButton({
    Key? key,
  required this.title,
  required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.yellow[700],
          boxShadow: boxShadow,
          borderRadius: BorderRadius.circular(25.0),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}


