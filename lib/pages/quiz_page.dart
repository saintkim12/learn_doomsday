import 'dart:math';
import 'package:flutter/material.dart';
import 'package:learn_doomsday/models/doomsday_date.dart';
import 'package:learn_doomsday/models/quiz.dart';
import 'package:learn_doomsday/services/doomsday_calculator.dart';

/// 둠스데이 알고리즘 퀴즈 페이지
///
/// 사용자가 랜덤으로 생성된 날짜의 요일을 맞추는 퀴즈 화면입니다.
///
/// 주요 기능:
/// 1. 랜덤 날짜 생성 (1900-2100년 범위)
/// 2. DoomsdayCalculator를 사용한 정답 계산
/// 3. 사용자 답변 검증 및 즉시 피드백
/// 4. 계산 과정 설명 제공
/// 5. 퀴즈 세션 관리 (10문제)
/// 6. 진행률 및 점수 표시
///
/// 리팩토링 이력:
/// - 기존: 하드코딩된 날짜, 정답 검증 없음
/// - 현재: DoomsdayCalculator 통합, QuizSession 사용, 완전한 피드백 시스템
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  /// 둠스데이 알고리즘 계산기 인스턴스
  /// 요일 계산 및 정답 검증에 사용됩니다
  final DoomsdayCalculator _calculator = DoomsdayCalculator();

  /// 현재 퀴즈 세션 (10문제 포함)
  /// QuizSession 모델을 사용하여 진행 상태, 점수 등을 관리합니다
  late QuizSession _session;

  /// 현재 문제의 정답을 표시할지 여부
  /// true: 사용자가 답변을 선택하여 결과를 확인한 상태
  /// false: 아직 답변하지 않은 상태
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    // 페이지 로드 시 퀴즈 세션 초기화
    _initializeQuizSession();
  }

  /// 퀴즈 세션 초기화 (10문제 생성)
  ///
  /// 새로운 퀴즈 세션을 시작하거나 재시작할 때 호출됩니다.
  /// 랜덤한 10개의 퀴즈 문제를 생성하고 QuizSession 객체를 초기화합니다.
  void _initializeQuizSession() {
    // List.generate를 사용하여 10개의 랜덤 퀴즈 생성
    final quizzes = List.generate(10, (index) => _generateQuiz());
    _session = QuizSession(quizzes: quizzes);
  }

  /// 랜덤 퀴즈 생성
  ///
  /// 1900년부터 2100년 사이의 임의의 날짜를 생성하고,
  /// DoomsdayCalculator를 사용하여 정답을 계산합니다.
  ///
  /// 생성 과정:
  /// 1. 랜덤 연도 선택 (1900-2100)
  /// 2. 랜덤 월 선택 (1-12)
  /// 3. 해당 월의 유효한 일자 범위 내에서 랜덤 일 선택
  ///    - 2월: 윤년이면 29일, 평년이면 28일
  ///    - 4, 6, 9, 11월: 30일
  ///    - 나머지: 31일
  /// 4. DoomsdayCalculator로 정답 계산
  ///
  /// 반환: Quiz 객체 (targetDate와 correctAnswer 포함)
  Quiz _generateQuiz() {
    final random = Random();

    // 1단계: 랜덤 연도 생성 (1900-2100)
    final year = 1900 + random.nextInt(201); // nextInt(201): 0~200 -> 1900~2100

    // 2단계: 랜덤 월 생성 (1-12)
    final month = 1 + random.nextInt(12);     // nextInt(12): 0~11 -> 1~12

    // 3단계: 월별 최대 일수 계산
    int maxDay;
    if (month == 2) {
      // 2월: 윤년 확인
      maxDay = _calculator.isLeapYear(year) ? 29 : 28;
    } else if ([4, 6, 9, 11].contains(month)) {
      // 소월(4, 6, 9, 11월): 30일
      maxDay = 30;
    } else {
      // 대월(1, 3, 5, 7, 8, 10, 12월): 31일
      maxDay = 31;
    }

    // 4단계: 랜덤 일 생성 (1~maxDay)
    final day = 1 + random.nextInt(maxDay);

    // 5단계: DoomsdayDate 객체 생성
    final targetDate = DoomsdayDate(year: year, month: month, day: day);

    // 6단계: 정답 계산 (DoomsdayCalculator 사용)
    final correctAnswer = _calculator.calculateDayOfWeekFromDate(targetDate.toDateTime());

    // 7단계: Quiz 객체 생성 및 반환
    return Quiz(targetDate: targetDate, correctAnswer: correctAnswer);
  }

  /// 요일 선택 처리
  ///
  /// 사용자가 요일을 선택했을 때 호출됩니다.
  /// Quiz 모델에 사용자의 답변을 저장하고 피드백을 표시합니다.
  ///
  /// 동작:
  /// 1. 이미 답변한 경우 무시 (중복 선택 방지)
  /// 2. 현재 퀴즈에 사용자 답변 저장
  /// 3. _showAnswer를 true로 설정하여 피드백 UI 표시
  ///
  /// 파라미터:
  /// - day: 사용자가 선택한 요일 ('월', '화', '수', '목', '금', '토', '일')
  void _selectDay(String day) {
    // 이미 답변을 확인한 경우 선택 불가 (재선택 방지)
    if (_showAnswer) return;

    setState(() {
      // Quiz 모델에 사용자 답변 저장
      _session.currentQuiz?.setUserAnswer(day);
      // 피드백 UI 표시
      _showAnswer = true;
    });
  }

  /// 다음 문제로 이동
  ///
  /// "다음 문제" 또는 "결과 보기" 버튼 클릭 시 호출됩니다.
  ///
  /// 동작:
  /// 1. QuizSession의 moveToNext()를 호출하여 다음 문제로 이동
  /// 2. 다음 문제가 있으면 _showAnswer를 false로 초기화
  /// 3. 마지막 문제인 경우 결과 다이얼로그 표시
  void _nextQuestion() {
    if (_session.moveToNext()) {
      // 다음 문제가 있는 경우
      setState(() {
        _showAnswer = false; // 피드백 숨기기
      });
    } else {
      // 마지막 문제인 경우 결과 화면 표시
      _showResultDialog();
    }
  }

  /// 결과 다이얼로그 표시
  ///
  /// 퀴즈 세션이 완료되었을 때 최종 점수와 정답률을 보여줍니다.
  ///
  /// 표시 내용:
  /// - 총 문제 수 및 정답 개수
  /// - 정답률 (백분율)
  ///
  /// 사용자 선택:
  /// - "다시 하기": 새로운 퀴즈 세션 시작
  /// - "메인으로": 메인 페이지로 돌아가기
  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('퀴즈 완료!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('총 ${_session.totalCount}문제 중 ${_session.correctCount}문제 정답!'),
            const SizedBox(height: 8),
            Text('정답률: ${(_session.accuracy * 100).toStringAsFixed(1)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              setState(() {
                _initializeQuizSession(); // 새 세션 시작
                _showAnswer = false;
              });
            },
            child: const Text('다시 하기'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 퀴즈 페이지 닫기
            },
            child: const Text('메인으로'),
          ),
        ],
      ),
    );
  }

  /// 계산 과정 설명 다이얼로그 표시
  ///
  /// 현재 문제의 정답을 둠스데이 알고리즘을 사용하여 계산하는 과정을
  /// 단계별로 보여줍니다. 사용자가 알고리즘을 이해하는 데 도움을 줍니다.
  ///
  /// 표시되는 정보:
  /// 1. 연도의 둠스데이 요일 (예: 2025년 -> 금요일)
  /// 2. 해당 월의 둠스데이 날짜 (예: 7월 -> 11일)
  /// 3. 목표 날짜와의 차이 (예: 15일 - 11일 = 4일)
  /// 4. 최종 요일 계산 (예: 금요일 + 4일 = 화요일)
  ///
  /// 주의: 답변 후에만 활성화됩니다 (_showAnswer가 true일 때)
  void _showExplanationDialog() {
    final quiz = _session.currentQuiz;
    if (quiz == null) return;

    // 현재 문제의 날짜 정보 추출
    final date = quiz.targetDate;
    final year = date.year;
    final month = date.month;
    final day = date.day;

    // 둠스데이 알고리즘 계산 과정 (4단계)

    // 1단계: 해당 연도의 둠스데이 요일 계산
    final doomsdayOfYear = _calculator.calculateDoomsdayOfYear(year);
    final doomsdayOfYearStr = _calculator.getWeekdayString(doomsdayOfYear);

    // 2단계: 해당 월의 둠스데이 날짜 찾기
    final doomsdateOfMonth = _calculator.getDoomsdayDateOfMonth(year, month);

    // 3단계: 목표 날짜와 둠스데이 날짜의 차이 계산
    final offset = day - doomsdateOfMonth;

    // 4단계: 최종 정답
    final correctWeekday = quiz.correctAnswer;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('계산 과정'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('문제: ${date.toKoreanString()}은 무슨 요일?'),
              const Divider(),
              const Text('1단계: 연도의 둠스데이 구하기'),
              Text('→ $year년의 둠스데이는 $doomsdayOfYearStr요일'),
              const SizedBox(height: 8),
              const Text('2단계: 월별 둠스데이 날짜 찾기'),
              Text('→ $month월의 둠스데이는 $month월 $doomsdateOfMonth일'),
              const SizedBox(height: 8),
              const Text('3단계: 날짜 차이 계산'),
              Text('→ $month월 $day일 - $month월 $doomsdateOfMonth일 = $offset일'),
              const SizedBox(height: 8),
              const Text('4단계: 요일 계산'),
              Text('→ $doomsdayOfYearStr요일 + $offset일 = $correctWeekday요일'),
              const Divider(),
              Text(
                '답: $correctWeekday요일',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// 힌트 다이얼로그 표시
  void _showHintDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('둠스데이 알고리즘 힌트'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('둠스데이 규칙은 특정 연도의 기준 요일을 이용해,'),
              Text('어떤 날짜의 요일이든 쉽게 구하는 방법입니다.'),
              SizedBox(height: 8),
              Text('단계:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('1. 연도의 둠스데이 요일을 구하고,'),
              Text('2. 월별로 정해진 기준일을 찾은 뒤,'),
              Text('3. 기준일과 목표 날짜의 차이에 따라 요일을 이동합니다.'),
              SizedBox(height: 8),
              Text('월별 둠스데이:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('1월: 3일(평년) / 4일(윤년)'),
              Text('2월: 28일(평년) / 29일(윤년)'),
              Text('3월: 7일'),
              Text('4월: 4일, 6월: 6일, 8월: 8일'),
              Text('10월: 10일, 12월: 12일'),
              Text('5월: 9일, 9월: 5일'),
              Text('7월: 11일, 11월: 7일'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 현재 퀴즈 가져오기
    final quiz = _session.currentQuiz;

    // 퀴즈가 없는 경우 (비정상 상태)
    if (quiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('연습하기')),
        body: const Center(child: Text('퀴즈를 불러올 수 없습니다.')),
      );
    }

    // 현재 퀴즈의 상태 확인
    final isAnswered = quiz.isAnswered;  // 사용자가 답변했는지
    final isCorrect = quiz.isCorrect;    // 정답인지 (답변한 경우만 의미있음)

    return Scaffold(
      // AppBar: 현재 문제 번호 표시 (예: "연습하기 (3/10)")
      appBar: AppBar(
        title: Text('연습하기 (${_session.currentIndex + 1}/${_session.totalCount})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // === 진행률 표시 영역 ===
            // 상단에 진행률 바를 표시하여 전체 진행 상황을 시각화
            LinearProgressIndicator(
              value: (_session.currentIndex + 1) / _session.totalCount,
            ),
            const SizedBox(height: 32),

            // === 문제 표시 영역 ===
            // 랜덤으로 생성된 날짜를 한글 형식으로 표시 (예: "2025년 7월 15일")
            Text(
              quiz.targetDate.toKoreanString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // === 요일 선택 영역 ===
            // 사용자가 요일을 선택하는 버튼과 텍스트
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  // 답변 후에는 버튼 비활성화 (재선택 방지)
                  onPressed: _showAnswer ? null : () => _showDaySelector(),
                  style: ElevatedButton.styleFrom(
                    // 답변 후 정답/오답에 따라 버튼 색상 변경
                    backgroundColor: isAnswered
                        ? (isCorrect ? Colors.green : Colors.red)  // 정답: 초록, 오답: 빨강
                        : null,  // 답변 전: 기본 색상
                    foregroundColor: isAnswered ? Colors.white : null,
                  ),
                  child: Text(quiz.userAnswer ?? '요일 선택'),  // 선택한 요일 또는 기본 텍스트
                ),
                const SizedBox(width: 8),
                const Text('요일입니다.', style: TextStyle(fontSize: 18)),
              ],
            ),

            // === 피드백 표시 영역 ===
            // 사용자가 답변한 후에만 표시 (조건부 렌더링)
            if (_showAnswer) ...[
              const SizedBox(height: 24),
              // 정답/오답 결과를 시각적으로 표시하는 컨테이너
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // 정답: 연한 초록 배경, 오답: 연한 빨강 배경
                  color: isCorrect ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCorrect ? Colors.green : Colors.red,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    // 정답/오답 아이콘
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? Colors.green : Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    // 정답/오답 텍스트
                    Text(
                      isCorrect ? '정답입니다!' : '틀렸습니다!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                    // 오답인 경우 정답 표시
                    if (!isCorrect) ...[
                      const SizedBox(height: 8),
                      Text(
                        '정답: ${quiz.correctAnswer}요일',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 다음 문제 또는 결과 보기 버튼
              ElevatedButton.icon(
                onPressed: _nextQuestion,
                icon: const Icon(Icons.arrow_forward),
                label: Text(
                  // 마지막 문제인 경우 "결과 보기", 아니면 "다음 문제"
                  _session.currentIndex < _session.totalCount - 1
                      ? '다음 문제'
                      : '결과 보기',
                ),
              ),
            ],

            const SizedBox(height: 32),

            // === 하단 도움말 버튼 영역 ===
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 힌트 버튼: 둠스데이 알고리즘 설명 및 월별 둠스데이 날짜 표시
                TextButton.icon(
                  onPressed: _showHintDialog,
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('힌트'),
                ),
                const SizedBox(width: 16),
                // 계산 과정 버튼: 답변 후에만 활성화, 단계별 계산 과정 표시
                TextButton.icon(
                  onPressed: _showAnswer ? _showExplanationDialog : null,
                  icon: const Icon(Icons.calculate),
                  label: const Text('계산 과정'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // === 현재 점수 표시 ===
            // QuizSession의 correctCount와 answeredCount를 사용
            Text(
              '현재 점수: ${_session.correctCount}/${_session.answeredCount}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// 요일 선택 모달 표시
  ///
  /// 하단에서 올라오는 모달 시트(Bottom Sheet)를 표시하여
  /// 사용자가 7개 요일 중 하나를 선택할 수 있게 합니다.
  ///
  /// UI 구성:
  /// - 제목: "요일을 선택하세요"
  /// - 7개 버튼: 월, 화, 수, 목, 금, 토, 일
  ///
  /// 동작:
  /// 1. 사용자가 요일 버튼 클릭
  /// 2. _selectDay(day) 호출하여 답변 저장
  /// 3. 모달 자동 닫기
  /// 4. 피드백 UI 표시
  void _showDaySelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 모달 제목
              const Text(
                '요일을 선택하세요',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // 요일 버튼들 (Wrap을 사용하여 자동 줄바꿈)
              Wrap(
                spacing: 8, // 버튼 간 가로 간격
                children: ['월', '화', '수', '목', '금', '토', '일'].map(
                  (day) => ElevatedButton(
                    onPressed: () {
                      _selectDay(day);        // 선택한 요일 저장
                      Navigator.pop(context); // 모달 닫기
                    },
                    child: Text(day, style: const TextStyle(fontSize: 16)),
                  ),
                ).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
