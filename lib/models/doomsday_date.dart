/// 둠스데이 알고리즘에서 사용하는 날짜 정보를 담는 모델
class DoomsdayDate {
  final int year;
  final int month;
  final int day;

  DoomsdayDate({
    required this.year,
    required this.month,
    required this.day,
  });

  /// YYYY-MM-DD 형식의 문자열로부터 DoomsdayDate 생성
  factory DoomsdayDate.fromString(String dateString) {
    final parts = dateString.split('-');
    return DoomsdayDate(
      year: int.parse(parts[0]),
      month: int.parse(parts[1]),
      day: int.parse(parts[2]),
    );
  }

  /// DateTime 객체로부터 DoomsdayDate 생성
  factory DoomsdayDate.fromDateTime(DateTime date) {
    return DoomsdayDate(
      year: date.year,
      month: date.month,
      day: date.day,
    );
  }

  /// DoomsdayDate를 DateTime으로 변환
  DateTime toDateTime() {
    return DateTime(year, month, day);
  }

  /// YYYY-MM-DD 형식의 문자열로 변환
  String toDateString() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  /// YYYY년 MM월 DD일 형식의 문자열로 변환
  String toKoreanString() {
    return '$year년 $month월 $day일';
  }

  @override
  String toString() => toDateString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DoomsdayDate &&
        other.year == year &&
        other.month == month &&
        other.day == day;
  }

  @override
  int get hashCode => Object.hash(year, month, day);
}
