# CLAUDE.md

이 파일은 Claude Code(claude.ai/code)가 이 프로젝트 코드를 작업할 때 참고하는 가이드입니다.

## 프로젝트 개요

**learn_doomsday**는 둠스데이 알고리즘(Doomsday Algorithm)을 배우는 Flutter 교육 앱입니다. 둠스데이 알고리즘은 John Conway가 개발한 암산 기법으로, 특정 날짜의 요일을 빠르게 계산할 수 있는 방법입니다.

**대상 사용자**: 한국어 사용자
**현재 상태**: 모든 핵심 페이지 완성 (v1.0.0). API 연동 준비 완료, 테스트 및 추가 기능 구현 단계.

## 개발 명령어

### 필수 명령어
```bash
# 의존성 설치
flutter pub get

# 앱 실행 (디바이스/에뮬레이터 필요)
flutter run

# 특정 디바이스에서 핫 리로드로 실행
flutter run -d <device-id>

# 코드 분석
flutter analyze

# 테스트 실행
flutter test

# 플랫폼별 빌드
flutter build windows
flutter build apk
flutter build ios
```

### 린팅
- `flutter_lints: ^5.0.0` 사용
- 커밋 전 `flutter analyze` 실행 권장
- 불필요한 문자열 보간 괄호 및 final 필드 선호

## 코드 아키텍처

### 레이어 구조

명확한 관심사 분리를 위한 계층형 아키텍처:

```
lib/
├── models/          # 데이터 모델 및 도메인 엔티티
│   ├── doomsday_date.dart
│   ├── quiz.dart
│   └── historical_event.dart  ✨ 신규
├── services/        # 비즈니스 로직 및 알고리즘
│   ├── doomsday_calculator.dart
│   └── history_service.dart  ✨ 신규
├── widgets/         # 재사용 가능한 UI 컴포넌트
│   └── big_button.dart
├── pages/           # 전체 화면 페이지 위젯
│   ├── main_page.dart
│   ├── quiz_page.dart
│   ├── today_history_page.dart  ✨ 완성
│   └── learn_page.dart  ✨ 완성
└── main.dart        # 앱 진입점
```

### 핵심 컴포넌트

**1. DoomsdayCalculator 서비스** (`lib/services/doomsday_calculator.dart`)

앱의 핵심 - Conway의 둠스데이 알고리즘 구현:

- **주요 메서드**: `calculateWeekday(int year, int month, int day) -> int`
  - 요일을 정수로 반환 (0 = 일요일, 6 = 토요일)
  - 3단계 프로세스:
    1. 연도의 둠스데이 계산
    2. 월별 둠스데이 날짜 찾기
    3. 목표 날짜와의 차이 계산

- **헬퍼 메서드**:
  - `calculateDoomsdayOfYear(int year)` - 연도의 기준 요일 찾기
  - `getDoomsdayDateOfMonth(int year, int month)` - 월별 둠스데이 날짜 반환 (윤년 처리 포함)
  - `isLeapYear(int year)` - 윤년 감지
  - `calculateDayOfWeek()` - 한글 요일 문자열 반환 ('월', '화', 등)

**중요**: 계산기는 0-indexed 요일을 사용하지만 UI는 한글 요일명을 표시합니다. `weekdays` 상수가 정수를 한글 문자열로 매핑합니다.

**2. HistoryService** (`lib/services/history_service.dart`) ✨ 신규

역사적 사건 데이터를 제공하는 서비스:

- **현재**: 10개의 하드코딩된 테스트 데이터
- **미래**: API 연동 준비 완료 (Wikimedia API 권장)
- **주요 메서드**:
  - `getRandomEvent()` - 랜덤 역사적 사건 반환
  - `getEventByIndex(int)` - 인덱스로 사건 가져오기
  - `getTodayInHistory()` - 오늘 날짜의 역사적 사건 (있으면)

**API 연동 시**:
- Wikimedia Feed API 사용 권장
- `pubspec.yaml`에 `http` 패키지 추가 필요
- 주석 처리된 API 연동 코드 활성화

**3. 데이터 모델** (`lib/models/`)

- **DoomsdayDate**: 변환 유틸리티가 포함된 날짜 표현
  - `fromString(String)` - "YYYY-MM-DD" 형식 파싱
  - `toKoreanString()` - "YYYY년 MM월 DD일" 형식 변환
  - `toDateTime()` - Flutter DateTime으로 변환

- **HistoricalEvent**: 역사적 사건 모델 ✨ 신규
  - `year`, `month`, `day` - 사건 발생 날짜
  - `title` - 사건 제목
  - `description` - 상세 설명
  - `category` - 카테고리 (과학, 문화, 정치 등)
  - `toJson()`, `fromJson()` - API 연동용 변환 메서드

- **Quiz**: 답변 추적 기능이 있는 단일 퀴즈 문제
  - `targetDate`, `correctAnswer`, `userAnswer` 저장
  - `isCorrect` getter - 사용자 답변 정답 여부 확인
  - `isAnswered` getter - 사용자 응답 여부 확인

- **QuizSession**: 여러 퀴즈 문제 관리
  - 현재 문제 인덱스 추적
  - 점수 및 정답률 계산
  - `moveToNext()`, `moveToPrevious()` 네비게이션 제공
  - `isCompleted` - 모든 문제 답변 완료 확인

**4. UI 아키텍처**

- **BigButton 위젯**: Expanded 레이아웃의 재사용 가능한 버튼 컴포넌트
  - Row/Column/Flex 부모 안에서 사용 필수
  - `label` 및 선택적 `onPressed` 콜백 받음

- **MainPage**: 세 가지 네비게이션 옵션이 있는 홈 화면
  - "연습하기" - QuizPage로 이동
  - "오늘의 역사" - TodayHistoryPage로 이동 ✅
  - "다시 배우기" - LearnPage로 이동 ✅

- **QuizPage**: 완전히 구현된 퀴즈 인터페이스 ✅
  - DoomsdayCalculator 서비스 통합 완료
  - 1900-2100년 범위의 랜덤 날짜 생성
  - Quiz/QuizSession 모델을 활용한 상태 관리
  - 즉시 피드백 시스템 (정답/오답 표시)
  - 단계별 계산 과정 설명 다이얼로그
  - 힌트 시스템 (알고리즘 학습 가이드)
  - 10문제 세션 관리
  - 진행률 바 및 점수 추적

- **TodayHistoryPage**: 역사 퀴즈 페이지 ✅ 완성
  - 랜덤 역사적 사건 표시 (10개 테스트 데이터)
  - 사건이 일어난 날짜의 요일 맞추기
  - 카테고리별 색상 및 아이콘 (7가지)
  - 계산 과정 상세 설명
  - 다음 문제 기능
  - **학습 효과**: 역사와 날짜를 연결하여 기억력 향상

- **LearnPage**: 단계별 학습 튜토리얼 ✅ 완성
  - 5단계 학습 콘텐츠
    1. 둠스데이 알고리즘 소개
    2. 연도의 둠스데이 구하기
    3. 월별 둠스데이 날짜 암기법
    4. 날짜 차이로 요일 구하기
    5. 종합 정리 및 연습 방법
  - 진행률 표시 및 단계별 네비게이션
  - 시각적으로 구분된 학습 자료

### 상태 관리

현재 로컬 상태의 StatefulWidget 사용. 상태 관리 라이브러리(Provider, Riverpod 등)는 설치되지 않음.

Provider나 Riverpod 추가 시:
- `pubspec.yaml`에 의존성 추가
- `lib/providers/` 디렉토리에 프로바이더 생성
- `main.dart`에서 MyApp을 프로바이더 스코프로 감싸기

## Import 규칙

패키지 import 사용, 상대 import 사용 금지:

```dart
// 올바름
import 'package:learn_doomsday/models/quiz.dart';
import 'package:learn_doomsday/services/doomsday_calculator.dart';

// 잘못됨
import '../models/quiz.dart';
```

## 테스트 참고사항

- `test/widget_test.dart`가 존재하지만 오래됨
- DoomsdayCalculator 테스트 미존재 (추가 필요)
- 계산기 테스트 시 검증 항목:
  - 윤년 감지
  - 알려진 날짜 (예: 2000-01-01은 토요일)
  - 월 경계 케이스 (윤년의 1월/2월)
  - 음수 offset (목표 날짜가 둠스데이 날짜보다 앞선 경우)

## 한국어 컨텍스트

모든 사용자 대면 텍스트는 한글:
- 요일: '월', '화', '수', '목', '금', '토', '일' (월-일)
- UI 레이블은 한글
- 주석은 한글/영어 혼용

## 다음 개발 우선순위

### ✅ 완료됨
1. ✅ QuizPage에 DoomsdayCalculator 통합
2. ✅ 퀴즈 피드백 UI 추가
3. ✅ 랜덤 날짜 생성 구현
4. ✅ QuizSession 추적 추가
5. ✅ "오늘의 역사" 페이지 구현 (역사 퀴즈 방식)
6. ✅ "다시 배우기" 페이지 구현 (5단계 튜토리얼)
7. ✅ HistoricalEvent 모델 및 HistoryService 구현
8. ✅ 10개 테스트 역사 데이터 추가

### 🎯 다음 단계

**우선순위 1: API 연동**
1. **Wikimedia Feed API 통합** - 추천 API (무료, 한국어 지원)
   - `pubspec.yaml`에 `http: ^1.1.0` 추가
   - `HistoryService`에서 API 호출 구현
   - 한국어/영어 데이터 혼합 전략
   - 에러 처리 및 로딩 상태 UI

**우선순위 2: 테스트 작성**
- DoomsdayCalculator 유닛 테스트 추가
- HistoricalEvent 모델 테스트
- 알려진 날짜로 정확도 검증
- 윤년 처리 테스트
- 경계값 테스트

**우선순위 3: 추가 기능**
- TodayHistoryPage 개선:
  - 중복 방지 (최근 본 사건 제외)
  - 카테고리 필터링
  - 즐겨찾기 기능
- 난이도 선택 (연도 범위 조절)
- 학습 통계 (정답률, 학습 시간)
- 연습 기록 저장 (SharedPreferences)
- 타이머 모드 (시간 제한 퀴즈)
- 테마 선택 (다크 모드)

**우선순위 4: UI/UX 개선**
- `withOpacity` → `withValues()` 마이그레이션
- 애니메이션 추가
- 접근성 개선

## API 연동 가이드

### 추천 API: Wikimedia Feed API

**엔드포인트**:
```
https://api.wikimedia.org/feed/v1/wikipedia/{언어}/onthisday/all/{월}/{일}
```

**장점**:
- ✅ 완전 무료, 인증키 불필요
- ✅ 한국어 지원 (언어 코드: `ko`)
- ✅ 위키미디어 공식 API (안정적)
- ✅ 무제한 요청

**사용 예시**:
```dart
// 한국어 데이터
https://api.wikimedia.org/feed/v1/wikipedia/ko/onthisday/all/7/20

// 영어 데이터
https://api.wikimedia.org/feed/v1/wikipedia/en/onthisday/all/7/20
```

**대체 옵션**:
- Day in History API: https://dayinhistory.dev/ (영어만, 시간당 10회)
- Muffinlabs: http://history.muffinlabs.com/ (무료, 영어)

**참고 문서**:
- [Wikimedia Feed API 공식 문서](https://api.wikimedia.org/wiki/Feed_API/Reference/On_this_day)

## 기술 참고사항

### 둠스데이 알고리즘 핵심 원리
- 매년 특정 날짜들(4/4, 6/6, 8/8, 10/10, 12/12 등)은 모두 같은 요일
- 이 기준 요일을 "둠스데이"라 부름
- 목표 날짜와 가장 가까운 둠스데이 날짜의 차이로 요일 계산

### 월별 둠스데이 날짜 암기법
- **짝수 달**: 달과 일이 같음 (4/4, 6/6, 8/8, 10/10, 12/12)
- **홀수 달**: 5/9와 9/5, 7/11과 11/7 (서로 바꾸면 됨)
- **1-2월**: 윤년 주의
  - 1월: 3일(평년) / 4일(윤년)
  - 2월: 28일(평년) / 29일(윤년)
  - 암기: "3년에 한 번, 4년에 한 번" 또는 "2월의 마지막 날"

### 계산 예시
**2025년 7월 15일의 요일은?**
1. 2025년의 둠스데이: 금요일
2. 7월의 둠스데이 날짜: 11일
3. 날짜 차이: 15 - 11 = 4일
4. 최종 요일: 금요일 + 4일 = 화요일

## 역사 데이터 구조

### 테스트 데이터 (10개)
현재 `HistoryService`에 포함된 주요 사건:
1. 1969.7.20 - 인류 최초 달 착륙 (과학)
2. 1446.10.9 - 훈민정음 반포 (문화)
3. 1989.11.9 - 베를린 장벽 붕괴 (정치)
4. 1948.8.15 - 대한민국 정부 수립 (정치)
5. 1912.4.14 - 타이타닉호 침몰 (사건)
6. 1879.3.14 - 아인슈타인 탄생 (과학)
7. 1950.6.25 - 6.25 전쟁 발발 (전쟁)
8. 1903.12.17 - 라이트 형제 첫 비행 (과학)
9. 1919.3.1 - 3.1 독립만세운동 (독립운동)
10. 2002.5.31 - 한일 월드컵 개막 (스포츠)

### 카테고리 시스템
- 과학 (파란색, science 아이콘)
- 문화 (보라색, palette 아이콘)
- 정치 (빨간색, account_balance 아이콘)
- 전쟁 (주황색, shield 아이콘)
- 독립운동 (초록색, flag 아이콘)
- 스포츠 (청록색, sports_soccer 아이콘)
- 사건 (갈색, event 아이콘)

## 코드 스타일 가이드

- 한글 주석 사용 권장 (코드 가독성 향상)
- 복잡한 로직에는 상세한 주석 작성
- 매직 넘버 사용 지양 (상수로 정의)
- 메서드는 하나의 책임만 가지도록 작성
- 위젯은 가능한 작고 재사용 가능하게 분리

## 추가 참고 자료

- [둠스데이 알고리즘 위키백과](https://ko.wikipedia.org/wiki/둠스데이_알고리즘)
- Flutter 공식 문서: https://flutter.dev/docs
- Dart 스타일 가이드: https://dart.dev/guides/language/effective-dart/style
- Wikimedia API 문서: https://api.wikimedia.org/
