import 'package:quizzie/models/question_models.dart';

import '../../enums/difficulty.dart';

abstract class BaseQuizRepository {

  Future<List<Question>> getQuestions({
    required int numQuestions,
    required int categoryId,
    required Difficulty difficulty,
  });
}
