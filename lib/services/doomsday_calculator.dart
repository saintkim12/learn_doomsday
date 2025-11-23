/// 둠스데이 알고리즘을 사용하여 날짜의 요일을 계산하는 서비스
///
/// 둠스데이 알고리즘(Doomsday Algorithm)은 John Conway가 개발한 알고리즘으로,
/// 특정 연도의 기준 요일(둠스데이)을 이용하여 어떤 날짜의 요일이든 빠르게 계산할 수 있습니다.
///
/// 핵심 원리:
/// 1. 매년 특정 날짜들은 모두 같은 요일입니다 (예: 4/4, 6/6, 8/8, 10/10, 12/12)
/// 2. 이 기준 날짜들의 요일을 "둠스데이"라고 합니다
/// 3. 목표 날짜와 가장 가까운 둠스데이 날짜의 차이를 계산하여 요일을 구합니다
class DoomsdayCalculator {
  /// 요일 상수 (0 = 일요일, 1 = 월요일, ..., 6 = 토요일)
  /// 주의: 0-based 인덱스를 사용하여 mod 연산과 호환됩니다
  static const List<String> weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  /// 월별 둠스데이 날짜 (평년 기준)
  ///
  /// 매년 다음 날짜들은 모두 같은 요일입니다:
  /// - 짝수 달: 4/4, 6/6, 8/8, 10/10, 12/12 (쉽게 기억: 달과 일이 같음)
  /// - 홀수 달: 3/7, 5/9, 7/11, 9/5, 11/7 (쉽게 기억: 5-9, 7-11, 9-5, 11-7)
  /// - 1월, 2월은 윤년 여부에 따라 다름
  ///
  /// 1월: 3일(평년)/4일(윤년), 2월: 28일(평년)/29일(윤년)
  static const Map<int, int> doomsdates = {
    1: 3,   // 1월 3일 (평년) / 1월 4일 (윤년)
    2: 28,  // 2월 28일 (평년) / 2월 29일 (윤년)
    3: 7,   // 3월 7일 (또는 3/0 = 3월 마지막 날)
    4: 4,   // 4월 4일
    5: 9,   // 5월 9일
    6: 6,   // 6월 6일
    7: 11,  // 7월 11일
    8: 8,   // 8월 8일
    9: 5,   // 9월 5일
    10: 10, // 10월 10일
    11: 7,  // 11월 7일
    12: 12, // 12월 12일
  };

  /// 윤년 여부를 확인
  ///
  /// 윤년 규칙:
  /// - 400으로 나누어떨어지면 윤년
  /// - 100으로 나누어떨어지면 평년
  /// - 4로 나누어떨어지면 윤년
  /// - 그 외는 평년
  ///
  /// 예: 2000년(윤년), 1900년(평년), 2024년(윤년), 2023년(평년)
  bool isLeapYear(int year) {
    if (year % 400 == 0) return true;  // 400의 배수는 윤년
    if (year % 100 == 0) return false; // 100의 배수는 평년
    if (year % 4 == 0) return true;    // 4의 배수는 윤년
    return false;                       // 나머지는 평년
  }

  /// 해당 연도의 둠스데이 요일을 계산 (0 = 일요일, 6 = 토요일)
  ///
  /// Conway's Doomsday Algorithm을 사용하여 특정 연도의 기준 요일을 계산합니다.
  /// 이 요일은 해당 연도의 모든 둠스데이 날짜(4/4, 6/6, 8/8 등)의 요일입니다.
  ///
  /// 계산 방법:
  /// 1. 세기의 anchor day를 구합니다 (각 세기마다 기준 요일이 다름)
  /// 2. 세기 내에서 연도의 offset을 계산합니다
  /// 3. 두 값을 더해 최종 둠스데이를 구합니다
  ///
  /// 예: 2025년의 둠스데이는 금요일(5)
  int calculateDoomsdayOfYear(int year) {
    // 1단계: 세기와 세기 내 연도 분리
    // 예: 2025년 -> 세기: 20, 세기 내 연도: 25
    int century = year ~/ 100;
    int yearInCentury = year % 100;

    // 2단계: 세기별 anchor day (기준 요일) 계산
    // 패턴: 화(2) -> 일(0) -> 금(5) -> 수(3) -> 화(2) ... (400년 주기)
    // 1800년대: 금(5), 1900년대: 수(3), 2000년대: 화(2), 2100년대: 일(0)
    int anchorDay = (5 * (century % 4) + 2) % 7;

    // 3단계: 세기 내에서 연도의 offset 계산
    // "Odd+11" 방법을 단순화한 버전
    int a = yearInCentury ~/ 12;  // 12년마다 1 추가
    int b = yearInCentury % 12;   // 12로 나눈 나머지
    int c = b ~/ 4;               // 4년마다 1 추가 (윤년 보정)

    // 4단계: 최종 둠스데이 계산
    // anchor day + offset을 더하고 7로 나눈 나머지가 요일
    int doomsday = (anchorDay + a + b + c) % 7;
    return doomsday;
  }

  /// 해당 월의 둠스데이 날짜를 반환
  ///
  /// 각 월마다 정해진 둠스데이 날짜를 반환합니다.
  /// 1월과 2월은 윤년 여부에 따라 다릅니다.
  ///
  /// 예:
  /// - getDoomsdayDateOfMonth(2024, 1) -> 4 (윤년이므로 1월 4일)
  /// - getDoomsdayDateOfMonth(2023, 1) -> 3 (평년이므로 1월 3일)
  /// - getDoomsdayDateOfMonth(2024, 4) -> 4 (4월 4일)
  int getDoomsdayDateOfMonth(int year, int month) {
    if (month == 1) {
      // 1월: 윤년이면 4일, 평년이면 3일
      return isLeapYear(year) ? 4 : 3;
    } else if (month == 2) {
      // 2월: 윤년이면 29일, 평년이면 28일
      return isLeapYear(year) ? 29 : 28;
    } else {
      // 3월~12월: 고정된 둠스데이 날짜 사용
      return doomsdates[month]!;
    }
  }

  /// 주어진 날짜의 요일을 계산 (0 = 일요일, 6 = 토요일)
  ///
  /// 둠스데이 알고리즘의 핵심 메서드입니다.
  /// 3단계 프로세스를 통해 임의의 날짜의 요일을 계산합니다.
  ///
  /// 계산 과정:
  /// 1. 연도의 둠스데이 요일 구하기 (예: 2025년 -> 금요일)
  /// 2. 해당 월의 둠스데이 날짜 구하기 (예: 7월 -> 11일)
  /// 3. 목표 날짜와의 차이를 계산하여 요일 구하기
  ///
  /// 예: 2025년 7월 15일의 요일 계산
  /// - 2025년의 둠스데이: 금요일(5)
  /// - 7월의 둠스데이 날짜: 11일
  /// - 날짜 차이: 15 - 11 = 4일
  /// - 최종 요일: (5 + 4) % 7 = 2 (화요일)
  int calculateWeekday(int year, int month, int day) {
    // 1단계: 해당 연도의 둠스데이 요일 구하기
    int doomsdayOfYear = calculateDoomsdayOfYear(year);

    // 2단계: 해당 월의 둠스데이 날짜 구하기
    int doomsdayDate = getDoomsdayDateOfMonth(year, month);

    // 3단계: 목표 날짜와 둠스데이 날짜의 차이 계산
    int offsetDays = day - doomsdayDate;

    // 4단계: 최종 요일 계산
    // 음수 차이를 처리하기 위해 7을 더한 후 mod 연산 수행
    // 예: 차이가 -3이면 -> (-3 % 7 + 7) % 7 = 4
    int weekday = (doomsdayOfYear + (offsetDays % 7) + 7) % 7;
    return weekday;
  }

  /// DateTime 객체로부터 요일 계산
  int calculateWeekdayFromDate(DateTime date) {
    return calculateWeekday(date.year, date.month, date.day);
  }

  /// 요일 숫자를 한글 문자열로 변환 (0 = 일, 1 = 월, ...)
  String getWeekdayString(int weekday) {
    return weekdays[weekday % 7];
  }

  /// 날짜의 요일을 한글 문자열로 반환
  String calculateDayOfWeek(int year, int month, int day) {
    int weekday = calculateWeekday(year, month, day);
    return getWeekdayString(weekday);
  }

  /// DateTime 객체의 요일을 한글 문자열로 반환
  String calculateDayOfWeekFromDate(DateTime date) {
    return calculateDayOfWeek(date.year, date.month, date.day);
  }

  /// 날짜 문자열(YYYY-MM-DD)로부터 요일 계산
  String calculateDayOfWeekFromString(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return calculateDayOfWeekFromDate(date);
    } catch (e) {
      return '잘못된 날짜';
    }
  }

  /// 두 요일이 일치하는지 확인
  bool isCorrectAnswer(String userAnswer, String correctAnswer) {
    return userAnswer == correctAnswer;
  }
}
