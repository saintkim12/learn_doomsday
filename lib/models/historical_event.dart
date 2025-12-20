/// 역사적 사건 모델
///
/// 특정 날짜에 발생한 역사적 사건을 나타냅니다.
/// "그날의 역사" 페이지에서 사용되며, 사용자는 역사적 사건을 읽고
/// 해당 날짜의 요일을 맞추는 퀴즈를 풀게 됩니다.
class HistoricalEvent {
  /// 사건이 발생한 연도
  final int year;

  /// 사건이 발생한 월 (1-12)
  final int month;

  /// 사건이 발생한 일 (1-31)
  final int day;

  /// 사건의 제목 (간결하게, 1-2줄)
  final String title;

  /// 사건의 상세 설명 (2-3줄 정도)
  final String description;

  /// 사건과 관련된 카테고리 (예: "과학", "정치", "문화" 등)
  /// 향후 필터링이나 아이콘 표시에 사용 가능
  final String? category;

  /// 생성자
  const HistoricalEvent({
    required this.year,
    required this.month,
    required this.day,
    required this.title,
    required this.description,
    this.category,
  });

  /// 날짜를 "YYYY년 M월 D일" 형식으로 반환
  String get formattedDate => '$year년 $month월 $day일';

  /// 날짜를 "YYYY-MM-DD" 형식으로 반환
  String get dateString {
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$year-$m-$d';
  }

  /// DateTime 객체로 변환
  DateTime toDateTime() => DateTime(year, month, day);

  /// JSON으로 변환 (향후 API 연동 시 사용)
  Map<String, dynamic> toJson() => {
        'year': year,
        'month': month,
        'day': day,
        'title': title,
        'description': description,
        'category': category,
      };

  /// JSON에서 생성 (향후 API 연동 시 사용)
  factory HistoricalEvent.fromJson(Map<String, dynamic> json) {
    return HistoricalEvent(
      year: json['year'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
    );
  }

  @override
  String toString() => 'HistoricalEvent($formattedDate: $title)';
}
