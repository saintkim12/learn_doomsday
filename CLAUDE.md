# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter educational app called "learn_doomsday" that teaches users the Doomsday algorithm - a mental math technique for calculating the day of the week for any given date. The app is written in Korean and targets Korean-speaking users.

**Current Status**: Early development stage (v1.0.0). Core architecture has been refactored but quiz functionality needs to be integrated with the calculator service.

## Development Commands

### Essential Commands
```bash
# Install dependencies
flutter pub get

# Run the app (requires device/emulator)
flutter run

# Run with hot reload on specific device
flutter run -d <device-id>

# Analyze code for issues
flutter analyze

# Run tests
flutter test

# Build for specific platform
flutter build windows
flutter build apk
flutter build ios
```

### Linting
- Uses `flutter_lints: ^5.0.0` with standard Flutter lint rules
- Run `flutter analyze` before committing
- The analyzer will flag unnecessary string interpolation braces and prefer final fields

## Code Architecture

### Layer Structure

The codebase follows a layered architecture with clear separation of concerns:

```
lib/
├── models/          # Data models and domain entities
├── services/        # Business logic and algorithms
├── widgets/         # Reusable UI components
├── pages/           # Full-screen page widgets
└── main.dart        # App entry point
```

### Core Components

**1. DoomsdayCalculator Service** (`lib/services/doomsday_calculator.dart`)

The heart of the application - implements Conway's Doomsday Algorithm:

- **Key method**: `calculateWeekday(int year, int month, int day) -> int`
  - Returns weekday as integer (0 = Sunday, 6 = Saturday)
  - Uses three-step process:
    1. Calculate the doomsday of the year
    2. Find the doomsday date for the month
    3. Calculate offset from target date

- **Helper methods**:
  - `calculateDoomsdayOfYear(int year)` - Finds anchor day for the year
  - `getDoomsdayDateOfMonth(int year, int month)` - Returns doomsday date for month (handles leap years)
  - `isLeapYear(int year)` - Leap year detection
  - `calculateDayOfWeek()` - Returns Korean weekday string ('월', '화', etc.)

**Important**: The calculator uses 0-indexed weekdays but the UI displays Korean day names. The `weekdays` constant maps integers to Korean strings.

**2. Data Models** (`lib/models/`)

- **DoomsdayDate**: Represents a date with conversion utilities
  - `fromString(String)` - Parses "YYYY-MM-DD" format
  - `toKoreanString()` - Formats as "YYYY년 MM월 DD일"
  - `toDateTime()` - Converts to Flutter DateTime

- **Quiz**: Single quiz question with answer tracking
  - Stores `targetDate`, `correctAnswer`, and `userAnswer`
  - `isCorrect` getter checks if user answered correctly
  - `isAnswered` getter checks if user has responded

- **QuizSession**: Manages multiple quiz questions
  - Tracks current question index
  - Calculates score and accuracy
  - Provides `moveToNext()` and `moveToPrevious()` navigation
  - `isCompleted` checks if all questions answered

**3. UI Architecture**

- **BigButton Widget**: Reusable button component with Expanded layout
  - Must be used inside Row/Column/Flex parent
  - Accepts `label` and optional `onPressed` callback

- **MainPage**: Home screen with three navigation options
  - "연습하기" (Practice) - navigates to QuizPage
  - "오늘의 역사" (Today's History) - not yet implemented
  - "다시 배우기" (Learn Again) - not yet implemented

- **QuizPage**: Quiz interface (currently basic UI only)
  - Displays target date
  - Shows modal bottom sheet for day selection
  - Hint dialog explains the Doomsday algorithm
  - **TODO**: Needs integration with DoomsdayCalculator service

## Critical Integration Points

### QuizPage Needs Implementation

The QuizPage currently has hardcoded date and no validation. To complete it:

1. **Import and instantiate DoomsdayCalculator**:
   ```dart
   final _calculator = DoomsdayCalculator();
   ```

2. **Generate random dates** instead of hardcoded `_targetDate`

3. **Calculate correct answer**:
   ```dart
   String correctAnswer = _calculator.calculateDayOfWeekFromString(_targetDate);
   ```

4. **Validate user selection** when they choose a day:
   ```dart
   bool isCorrect = _calculator.isCorrectAnswer(_selectedDay!, correctAnswer);
   ```

5. **Show feedback** (correct/incorrect) and explanation

6. **Create Quiz/QuizSession instances** to track progress

### State Management

Currently uses StatefulWidget with local state. No state management library is installed. If adding Provider or Riverpod:

- Add dependency to `pubspec.yaml`
- Create providers in `lib/providers/` directory
- Wrap MyApp with provider scope in `main.dart`

## Import Conventions

Use package imports, not relative imports:

```dart
// Correct
import 'package:learn_doomsday/models/quiz.dart';
import 'package:learn_doomsday/services/doomsday_calculator.dart';

// Incorrect
import '../models/quiz.dart';
```

## Testing Notes

- Test file exists at `test/widget_test.dart` but is outdated
- No tests exist for DoomsdayCalculator (should be added)
- When adding calculator tests, verify:
  - Leap year detection
  - Known dates (e.g., 2000-01-01 is Saturday)
  - Month boundary cases (January/February in leap years)

## Korean Language Context

All user-facing text is in Korean:
- Weekdays: '월', '화', '수', '목', '금', '토', '일' (Mon-Sun)
- UI labels are in Korean
- Comments mix Korean and English

## Next Development Priorities

1. **Integrate DoomsdayCalculator into QuizPage** - Core functionality missing
2. **Add quiz feedback UI** - Show correct/incorrect with explanation
3. **Implement random date generation** - Currently hardcoded
4. **Add QuizSession tracking** - Score and progress display
5. **Complete missing pages** - "오늘의 역사" and "다시 배우기"
