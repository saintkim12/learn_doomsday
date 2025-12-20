import 'package:flutter/material.dart';
import 'package:learn_doomsday/models/doomsday_date.dart';
import 'package:learn_doomsday/models/historical_event.dart';
import 'package:learn_doomsday/services/doomsday_calculator.dart';
import 'package:learn_doomsday/services/history_service.dart';

/// 그날의 역사 페이지
///
/// 역사적 사건을 소개하고, 그 날짜의 요일을 맞추는 퀴즈 페이지입니다.
///
/// 주요 기능:
/// 1. 랜덤 역사적 사건 표시
/// 2. 사건이 일어난 날짜의 요일 맞추기
/// 3. 정답 확인 및 계산 과정 설명
/// 4. 다음 문제로 이동
///
/// 학습 효과:
/// - 역사적 사건과 날짜를 연결하여 기억
/// - 둠스데이 알고리즘 반복 연습
/// - 역사 상식 습득
class TodayHistoryPage extends StatefulWidget {
  const TodayHistoryPage({super.key});

  @override
  State<TodayHistoryPage> createState() => _TodayHistoryPageState();
}

class _TodayHistoryPageState extends State<TodayHistoryPage> {
  /// 둠스데이 계산기 인스턴스
  final DoomsdayCalculator _calculator = DoomsdayCalculator();

  /// 역사 서비스 인스턴스
  final HistoryService _historyService = HistoryService();

  /// 현재 표시 중인 역사적 사건
  late HistoricalEvent _currentEvent;

  /// 사건 날짜의 DateTime 표현
  late DateTime _eventDate;

  /// 사건 날짜의 DoomsdayDate 표현
  late DoomsdayDate _eventDoomsdayDate;

  /// 둠스데이 알고리즘으로 계산한 정답
  late String _calculatedAnswer;

  /// 실제 요일 (검증용)
  late String _actualAnswer;

  /// 사용자가 선택한 요일
  String? _userAnswer;

  /// 답변을 확인했는지 여부
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadNewEvent();
  }

  /// 새로운 역사적 사건 로드
  void _loadNewEvent() {
    // 랜덤 역사적 사건 가져오기
    _currentEvent = _historyService.getRandomEvent();

    // 사건 날짜 설정
    _eventDate = _currentEvent.toDateTime();
    _eventDoomsdayDate = DoomsdayDate(
      year: _currentEvent.year,
      month: _currentEvent.month,
      day: _currentEvent.day,
    );

    // 정답 계산
    _calculatedAnswer = _calculator.calculateDayOfWeekFromDate(_eventDate);

    // 실제 요일 (검증용)
    final actualWeekday = _eventDate.weekday % 7;
    _actualAnswer = _calculator.getWeekdayString(actualWeekday);
  }

  /// 요일 선택 처리
  void _selectDay(String day) {
    if (_showAnswer) return;

    setState(() {
      _userAnswer = day;
      _showAnswer = true;
    });
  }

  /// 다음 문제로
  void _nextQuestion() {
    setState(() {
      _loadNewEvent();
      _userAnswer = null;
      _showAnswer = false;
    });
  }

  /// 계산 과정 설명 다이얼로그
  void _showExplanationDialog() {
    final year = _currentEvent.year;
    final month = _currentEvent.month;
    final day = _currentEvent.day;

    // 계산 과정 변수들
    final century = year ~/ 100;
    final yearInCentury = year % 100;
    final anchorDay = (5 * (century % 4) + 2) % 7;
    final anchorDayStr = _calculator.getWeekdayString(anchorDay);

    final a = yearInCentury ~/ 12;
    final b = yearInCentury % 12;
    final c = b ~/ 4;

    final doomsdayOfYear = _calculator.calculateDoomsdayOfYear(year);
    final doomsdayOfYearStr = _calculator.getWeekdayString(doomsdayOfYear);

    final doomsdateOfMonth = _calculator.getDoomsdayDateOfMonth(year, month);
    final offset = day - doomsdateOfMonth;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('계산 과정'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '문제: ${_eventDoomsdayDate.toKoreanString()}은 무슨 요일?',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Divider(),

              // 1단계
              const Text(
                '1단계: 연도의 둠스데이 구하기',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 4),
              Text('① 세기: $year년 = ${century}00년대'),
              Text('② ${century}00년대의 기준: $anchorDayStr요일'),
              Text('③ ${century}00년대에서 $year년까지:'),
              Text('   • $yearInCentury ÷ 12 = $a ... $b'),
              Text('   • $b ÷ 4 = $c'),
              Text('   • 합계: $a + $b + $c = ${a + b + c}'),
              Text('④ $anchorDayStr요일 + ${a + b + c}일 = $doomsdayOfYearStr요일'),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '∴ $year년의 둠스데이: $doomsdayOfYearStr요일',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),

              // 2단계
              const Text(
                '2단계: 월별 둠스데이 날짜',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 4),
              Text('$month월의 둠스데이 날짜: $doomsdateOfMonth일'),
              const SizedBox(height: 8),

              // 3단계
              const Text(
                '3단계: 날짜 차이',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 4),
              Text('$day - $doomsdateOfMonth = $offset일'),
              const SizedBox(height: 8),

              // 4단계
              const Text(
                '4단계: 최종 계산',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
              ),
              const SizedBox(height: 4),
              Text('$doomsdayOfYearStr요일 + $offset일 = $_calculatedAnswer요일'),

              const Divider(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '답: ${_eventDoomsdayDate.toKoreanString()}은 $_calculatedAnswer요일',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '실제: $_actualAnswer요일 (검증)',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
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

  /// 요일 선택 모달
  void _showDaySelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '이 날은 무슨 요일일까요?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: ['월', '화', '수', '목', '금', '토', '일'].map(
                  (day) => ElevatedButton(
                    onPressed: () {
                      _selectDay(day);
                      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final isAnswered = _userAnswer != null;
    final isCorrect = isAnswered && _userAnswer == _calculatedAnswer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 역사'),
        actions: [
          // 다음 문제 버튼 (답변 후에만 표시)
          if (_showAnswer)
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: _nextQuestion,
              tooltip: '다음 문제',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 역사적 사건 카드
            _buildHistoricalEventCard(),

            const SizedBox(height: 24),

            // 날짜 표시
            Center(
              child: Column(
                children: [
                  const Text(
                    '이 사건이 일어난 날은',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentEvent.formattedDate,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 퀴즈 안내
            const Text(
              '이 날은 무슨 요일이었을까요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // 요일 선택 버튼
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _showAnswer ? null : _showDaySelector,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAnswered
                          ? (isCorrect ? Colors.green : Colors.red)
                          : null,
                      foregroundColor: isAnswered ? Colors.white : null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      _userAnswer ?? '요일 선택',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('요일', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),

            // 피드백 표시
            if (_showAnswer) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCorrect ? Colors.green : Colors.red,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? Colors.green : Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isCorrect ? '정답입니다!' : '틀렸습니다!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                    if (!isCorrect) ...[
                      const SizedBox(height: 8),
                      Text(
                        '정답: $_calculatedAnswer요일',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '실제: $_actualAnswer요일',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _showExplanationDialog,
                    icon: const Icon(Icons.calculate),
                    label: const Text('계산 과정'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _nextQuestion,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('다음 문제'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 32),

            // 하단 팁
            if (!_showAnswer)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '역사적 사건과 날짜를 연결하면\n더 오래 기억에 남습니다!',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 역사적 사건 카드 위젯
  Widget _buildHistoricalEventCard() {
    // 카테고리별 아이콘 및 색상
    IconData categoryIcon;
    Color categoryColor;

    switch (_currentEvent.category) {
      case '과학':
        categoryIcon = Icons.science;
        categoryColor = Colors.blue;
        break;
      case '문화':
        categoryIcon = Icons.palette;
        categoryColor = Colors.purple;
        break;
      case '정치':
        categoryIcon = Icons.account_balance;
        categoryColor = Colors.red;
        break;
      case '전쟁':
        categoryIcon = Icons.shield;
        categoryColor = Colors.orange;
        break;
      case '독립운동':
        categoryIcon = Icons.flag;
        categoryColor = Colors.green;
        break;
      case '스포츠':
        categoryIcon = Icons.sports_soccer;
        categoryColor = Colors.teal;
        break;
      case '사건':
        categoryIcon = Icons.event;
        categoryColor = Colors.brown;
        break;
      default:
        categoryIcon = Icons.history_edu;
        categoryColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            categoryColor.withOpacity(0.1),
            categoryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: categoryColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          // 카테고리 아이콘
          Icon(
            categoryIcon,
            size: 48,
            color: categoryColor,
          ),
          const SizedBox(height: 12),

          // 카테고리 라벨
          if (_currentEvent.category != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _currentEvent.category!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: categoryColor,
                ),
              ),
            ),
          const SizedBox(height: 12),

          // 제목
          Text(
            _currentEvent.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // 설명
          Text(
            _currentEvent.description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
