import 'package:learn_doomsday/models/doomsday_date.dart';

/// 퀴즈 문제를 담는 모델
class Quiz {
  final DoomsdayDate targetDate;
  final String correctAnswer;
  String? userAnswer;

  Quiz({
    required this.targetDate,
    required this.correctAnswer,
    this.userAnswer,
  });

  /// 사용자의 답변 설정
  void setUserAnswer(String answer) {
    userAnswer = answer;
  }

  /// 정답 여부 확인
  bool get isCorrect => userAnswer == correctAnswer;

  /// 답변 여부 확인
  bool get isAnswered => userAnswer != null;

  /// 퀴즈를 초기화 (답변 제거)
  void reset() {
    userAnswer = null;
  }

  @override
  String toString() {
    return 'Quiz(date: ${targetDate.toDateString()}, correct: $correctAnswer, user: $userAnswer)';
  }
}

/// 퀴즈 세션 정보를 담는 모델 (여러 퀴즈 관리)
class QuizSession {
  final List<Quiz> quizzes;
  int currentIndex;

  QuizSession({
    required this.quizzes,
    this.currentIndex = 0,
  });

  /// 현재 퀴즈 가져오기
  Quiz? get currentQuiz {
    if (currentIndex >= 0 && currentIndex < quizzes.length) {
      return quizzes[currentIndex];
    }
    return null;
  }

  /// 다음 퀴즈로 이동
  bool moveToNext() {
    if (currentIndex < quizzes.length - 1) {
      currentIndex++;
      return true;
    }
    return false;
  }

  /// 이전 퀴즈로 이동
  bool moveToPrevious() {
    if (currentIndex > 0) {
      currentIndex--;
      return true;
    }
    return false;
  }

  /// 전체 퀴즈 개수
  int get totalCount => quizzes.length;

  /// 답변한 퀴즈 개수
  int get answeredCount => quizzes.where((q) => q.isAnswered).length;

  /// 정답 개수
  int get correctCount => quizzes.where((q) => q.isCorrect).length;

  /// 정답률 (0.0 ~ 1.0)
  double get accuracy {
    if (answeredCount == 0) return 0.0;
    return correctCount / answeredCount;
  }

  /// 모든 퀴즈를 답변했는지 확인
  bool get isCompleted => answeredCount == totalCount;

  /// 세션 초기화
  void reset() {
    for (var quiz in quizzes) {
      quiz.reset();
    }
    currentIndex = 0;
  }
}
