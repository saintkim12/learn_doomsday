import 'package:flutter/material.dart';

/// 다시 배우기 페이지
///
/// 둠스데이 알고리즘을 단계별로 학습할 수 있는 튜토리얼 페이지입니다.
///
/// 주요 내용:
/// 1. 둠스데이 알고리즘 소개
/// 2. 단계별 학습 가이드
/// 3. 월별 둠스데이 날짜 암기법
/// 4. 예제를 통한 실습
class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  /// 현재 보고 있는 단계 (0부터 시작)
  int _currentStep = 0;

  /// 전체 학습 단계 수
  final int _totalSteps = 5;

  /// 다음 단계로
  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  /// 이전 단계로
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('다시 배우기'),
      ),
      body: Column(
        children: [
          // 진행률 표시
          LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildStepContent(_currentStep),
            ),
          ),
          // 네비게이션 버튼
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 이전 버튼
                ElevatedButton.icon(
                  onPressed: _currentStep > 0 ? _previousStep : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('이전'),
                ),

                // 단계 표시
                Text(
                  '${_currentStep + 1} / $_totalSteps',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // 다음 버튼
                ElevatedButton.icon(
                  onPressed: _currentStep < _totalSteps - 1 ? _nextStep : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('다음'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 단계별 콘텐츠 빌드
  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return _buildIntroduction();
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
        return _buildPractice();
      default:
        return const SizedBox();
    }
  }

  /// 0단계: 소개
  Widget _buildIntroduction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '둠스데이 알고리즘이란?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '📚 둠스데이 알고리즘',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '수학자 존 콘웨이(John Conway)가 개발한 암산 기법으로, '
                '어떤 날짜든 그 날의 요일을 빠르게 계산할 수 있는 방법입니다.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '🎯 핵심 원리',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoBox(
          '매년 특정 날짜들은 모두 같은 요일입니다!',
          Colors.green,
        ),
        const SizedBox(height: 16),
        const Text(
          '예를 들어 2025년의 경우:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildDateList([
          '4월 4일',
          '6월 6일',
          '8월 8일',
          '10월 10일',
          '12월 12일',
        ], '이 날짜들은 모두 금요일입니다!'),
        const SizedBox(height: 16),
        const Text(
          '이렇게 같은 요일인 기준 날짜들을 이용하면, '
          '다른 날짜의 요일도 쉽게 계산할 수 있습니다.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        _buildInfoBox(
          '총 3단계만 거치면 어떤 날짜의 요일이든 알 수 있습니다!',
          Colors.orange,
        ),
      ],
    );
  }

  /// 1단계: 연도의 둠스데이 구하기
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1단계: 연도의 둠스데이 구하기',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '각 연도마다 기준이 되는 요일이 있습니다. '
          '이것을 "둠스데이"라고 부릅니다.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        const Text(
          '📝 계산 방법',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildCalculationStep('① 세기 구하기', '연도를 100으로 나눈 몫\n예: 2025년 → 20세기'),
        _buildCalculationStep('② 세기의 기준 요일', '각 세기마다 정해진 기준이 있음\n1900년대: 수요일\n2000년대: 화요일\n2100년대: 일요일'),
        _buildCalculationStep('③ 세기 내 offset', '연도를 계산하는 공식:\n• 년도 ÷ 12 = a ... b\n• b ÷ 4 = c\n• a + b + c를 더함'),
        _buildCalculationStep('④ 최종 둠스데이', '기준 요일 + offset = 둠스데이'),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '예제: 2025년의 둠스데이',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('① 세기: 20세기'),
              Text('② 2000년대 기준: 화요일'),
              Text('③ 25년 계산:'),
              Text('   • 25 ÷ 12 = 2 ... 1'),
              Text('   • 1 ÷ 4 = 0'),
              Text('   • 2 + 1 + 0 = 3'),
              Text('④ 화요일 + 3일 = 금요일'),
              SizedBox(height: 8),
              Text(
                '∴ 2025년의 둠스데이는 금요일',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 2단계: 월별 둠스데이 날짜
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2단계: 월별 둠스데이 날짜',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '각 월마다 정해진 둠스데이 날짜가 있습니다. '
          '이 날짜들을 외우면 계산이 훨씬 쉬워집니다!',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        const Text(
          '✨ 쉽게 외우는 방법',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildMemoryTip(
          '짝수 달',
          '달과 일이 같음!',
          ['4/4', '6/6', '8/8', '10/10', '12/12'],
          Colors.purple,
        ),
        const SizedBox(height: 16),
        _buildMemoryTip(
          '홀수 달',
          '서로 바꾸면 됨!',
          ['5/9와 9/5', '7/11과 11/7', '3/7 (또는 3/0)'],
          Colors.green,
        ),
        const SizedBox(height: 16),
        _buildMemoryTip(
          '1월과 2월',
          '윤년 주의!',
          [
            '1월: 3일 (평년) / 4일 (윤년)',
            '2월: 28일 (평년) / 29일 (윤년)',
          ],
          Colors.red,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '💡 암기 팁',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('짝수 달만 먼저 외우세요: 4/4, 6/6, 8/8, 10/10, 12/12'),
              Text('이것만 외워도 절반은 끝!'),
            ],
          ),
        ),
      ],
    );
  }

  /// 3단계: 날짜 차이로 요일 구하기
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3단계: 날짜 차이로 요일 구하기',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '이제 목표 날짜와 가장 가까운 둠스데이 날짜의 차이를 계산하면 됩니다!',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        const Text(
          '📝 계산 방법',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildCalculationStep(
          '① 목표 날짜 확인',
          '알고 싶은 날짜를 확인합니다',
        ),
        _buildCalculationStep(
          '② 둠스데이 날짜 찾기',
          '해당 월의 둠스데이 날짜를 찾습니다',
        ),
        _buildCalculationStep(
          '③ 날짜 차이 계산',
          '목표 날짜 - 둠스데이 날짜 = 차이',
        ),
        _buildCalculationStep(
          '④ 요일 이동',
          '둠스데이 요일에서 차이만큼 이동합니다',
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '예제: 2025년 7월 15일',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('① 목표: 7월 15일'),
              Text('② 7월의 둠스데이: 11일 (금요일)'),
              Text('③ 차이: 15 - 11 = 4일'),
              Text('④ 금요일 + 4일 = 화요일'),
              SizedBox(height: 8),
              Text(
                '∴ 2025년 7월 15일은 화요일',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '💡 음수가 나오면?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('목표 날짜가 둠스데이 날짜보다 앞서면 음수가 나옵니다.'),
              Text('이 경우 거꾸로 세면 됩니다!'),
              SizedBox(height: 4),
              Text('예: 7월 8일 - 7월 11일 = -3일'),
              Text('금요일에서 3일 뒤로 = 화요일'),
            ],
          ),
        ),
      ],
    );
  }

  /// 4단계: 종합 연습
  Widget _buildPractice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '종합 정리 및 연습',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '이제 배운 내용을 정리하고 실전에서 사용해봅시다!',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        const Text(
          '📋 전체 과정 요약',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildSummaryStep(
          '1',
          '연도의 둠스데이',
          '세기와 년도로 기준 요일 계산',
          Colors.blue,
        ),
        _buildSummaryStep(
          '2',
          '월별 둠스데이 날짜',
          '해당 월의 기준 날짜 찾기',
          Colors.orange,
        ),
        _buildSummaryStep(
          '3',
          '날짜 차이 계산',
          '목표 날짜와의 차이로 요일 구하기',
          Colors.green,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '🎯 실전 연습',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                '다음 날짜의 요일을 계산해보세요:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• 2024년 12월 25일 (크리스마스)'),
              Text('• 2026년 1월 1일 (새해 첫날)'),
              Text('• 여러분의 생일!'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '💪 연습 방법',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildTipBox('1. 홈 화면에서 "연습하기"를 선택하세요'),
        _buildTipBox('2. 랜덤으로 나오는 날짜의 요일을 맞춰보세요'),
        _buildTipBox('3. 틀렸다면 "계산 과정"을 눌러 어디서 실수했는지 확인하세요'),
        _buildTipBox('4. 반복 연습으로 속도를 높이세요!'),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[100]!, Colors.purple[100]!],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: const [
              Icon(Icons.emoji_events, size: 48, color: Colors.amber),
              SizedBox(height: 8),
              Text(
                '연습을 거듭하면\n3초 안에 계산할 수 있습니다!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 헬퍼 위젯들

  Widget _buildInfoBox(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildDateList(List<String> dates, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...dates.map((date) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(date, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              )),
          const Divider(),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryTip(
    String title,
    String subtitle,
    List<String> items,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('  • $item'),
              )),
        ],
      ),
    );
  }

  Widget _buildSummaryStep(
    String number,
    String title,
    String description,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipBox(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
