import 'dart:math';
import 'package:learn_doomsday/models/historical_event.dart';

/// 역사적 사건 데이터를 제공하는 서비스
///
/// 현재는 하드코딩된 테스트 데이터를 사용하지만,
/// 향후 API 연동 시 이 클래스만 수정하면 됩니다.
class HistoryService {
  /// 테스트용 역사적 사건 데이터 (10개)
  ///
  /// 한국 및 세계의 주요 역사적 사건을 포함합니다.
  /// 다양한 연도와 월을 고르게 분포시켰습니다.
  static final List<HistoricalEvent> _mockEvents = [
    // 1. 인류 최초 달 착륙
    const HistoricalEvent(
      year: 1969,
      month: 7,
      day: 20,
      title: '인류 최초 달 착륙',
      description: '아폴로 11호의 닐 암스트롱이 인류 역사상 처음으로 달 표면에 발을 디뎠습니다. '
          '"한 사람에게는 작은 발걸음이지만, 인류에게는 위대한 도약이다"라는 명언을 남겼습니다.',
      category: '과학',
    ),

    // 2. 한글 반포
    const HistoricalEvent(
      year: 1446,
      month: 10,
      day: 9,
      title: '훈민정음(한글) 반포',
      description: '세종대왕이 창제한 훈민정음이 반포되었습니다. '
          '백성을 가르치는 바른 소리라는 뜻의 한글은 세계에서 가장 과학적인 문자로 평가받고 있습니다.',
      category: '문화',
    ),

    // 3. 베를린 장벽 붕괴
    const HistoricalEvent(
      year: 1989,
      month: 11,
      day: 9,
      title: '베를린 장벽 붕괴',
      description: '동독과 서독을 나누던 베를린 장벽이 무너졌습니다. '
          '이는 냉전 종식의 상징적 사건이 되었으며, 이듬해 독일 통일로 이어졌습니다.',
      category: '정치',
    ),

    // 4. 대한민국 정부 수립
    const HistoricalEvent(
      year: 1948,
      month: 8,
      day: 15,
      title: '대한민국 정부 수립',
      description: '일본으로부터 광복을 맞이한 지 3년 만에 대한민국 정부가 공식 수립되었습니다. '
          '초대 대통령으로 이승만이 취임했습니다.',
      category: '정치',
    ),

    // 5. 타이타닉호 침몰
    const HistoricalEvent(
      year: 1912,
      month: 4,
      day: 14,
      title: '타이타닉호 침몰',
      description: '영국의 호화 여객선 타이타닉호가 북대서양에서 빙산과 충돌해 침몰했습니다. '
          '약 1,500명이 목숨을 잃은 해양 참사로 기록되었습니다.',
      category: '사건',
    ),

    // 6. 아인슈타인 출생
    const HistoricalEvent(
      year: 1879,
      month: 3,
      day: 14,
      title: '알베르트 아인슈타인 탄생',
      description: '20세기 최고의 물리학자 알베르트 아인슈타인이 독일에서 태어났습니다. '
          '상대성이론으로 현대 물리학의 기초를 확립했습니다.',
      category: '과학',
    ),

    // 7. 6.25 전쟁 발발
    const HistoricalEvent(
      year: 1950,
      month: 6,
      day: 25,
      title: '6.25 전쟁 발발',
      description: '북한군이 38도선을 넘어 남침하면서 한국전쟁이 시작되었습니다. '
          '3년간의 전쟁은 한반도에 큰 상처를 남겼습니다.',
      category: '전쟁',
    ),

    // 8. 라이트 형제 첫 비행
    const HistoricalEvent(
      year: 1903,
      month: 12,
      day: 17,
      title: '인류 최초 동력 비행 성공',
      description: '라이트 형제가 미국 노스캐롤라이나 키티호크에서 인류 최초로 동력 비행에 성공했습니다. '
          '12초간 36미터를 날았습니다.',
      category: '과학',
    ),

    // 9. 삼일운동
    const HistoricalEvent(
      year: 1919,
      month: 3,
      day: 1,
      title: '3·1 독립 만세 운동',
      description: '일제 강점기에 한국인들이 전국적으로 독립 만세 운동을 전개했습니다. '
          '평화적 시위였으나 일제의 무력 진압으로 많은 희생자가 발생했습니다.',
      category: '독립운동',
    ),

    // 10. 2002 한일 월드컵 개막
    const HistoricalEvent(
      year: 2002,
      month: 5,
      day: 31,
      title: '2002 FIFA 한일 월드컵 개막',
      description: '아시아 최초로 한국과 일본에서 공동 개최된 월드컵이 시작되었습니다. '
          '대한민국은 4강 신화를 이루며 전 국민을 열광시켰습니다.',
      category: '스포츠',
    ),
  ];

  /// 랜덤한 역사적 사건 하나를 반환
  ///
  /// 매번 다른 사건을 보여주어 사용자가 다양한 역사를 접할 수 있게 합니다.
  HistoricalEvent getRandomEvent() {
    final random = Random();
    return _mockEvents[random.nextInt(_mockEvents.length)];
  }

  /// 특정 인덱스의 역사적 사건 반환 (테스트용)
  HistoricalEvent getEventByIndex(int index) {
    if (index < 0 || index >= _mockEvents.length) {
      return _mockEvents[0]; // 범위 벗어나면 첫 번째 반환
    }
    return _mockEvents[index];
  }

  /// 전체 사건 개수
  int get totalEvents => _mockEvents.length;

  /// 오늘 날짜(MM-DD)와 일치하는 역사적 사건 반환 (있으면)
  ///
  /// 향후 "진짜 오늘의 역사" 기능 추가 시 사용 가능
  HistoricalEvent? getTodayInHistory() {
    final now = DateTime.now();
    try {
      return _mockEvents.firstWhere(
        (event) => event.month == now.month && event.day == now.day,
      );
    } catch (e) {
      return null; // 오늘과 일치하는 사건이 없으면 null
    }
  }

  // 🔮 향후 API 연동 시 사용할 메서드 예시
  //
  // Future<HistoricalEvent> fetchRandomEvent() async {
  //   final response = await http.get(
  //     Uri.parse('https://api.example.com/history/random'),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return HistoricalEvent.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load historical event');
  //   }
  // }
  //
  // Future<List<HistoricalEvent>> fetchTodayEvents() async {
  //   final now = DateTime.now();
  //   final response = await http.get(
  //     Uri.parse('https://api.example.com/history/today?month=${now.month}&day=${now.day}'),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> jsonList = jsonDecode(response.body);
  //     return jsonList.map((json) => HistoricalEvent.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load events');
  //   }
  // }
}
