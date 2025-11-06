import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    String targetDate = '2025-12-12';
    return Scaffold(
      appBar: AppBar(title: Text('연습하기')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('$targetDate 는'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          color: Colors.grey,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ...['월', '화', '수', '목', '금', '토', '일'].map(
                                      (e) => ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(e),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text('월'),
                ), // 간단한 버튼, 터치 시 하단 플로팅?팝업
                Text('요일입니다.'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('힌트'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('둠스데이 규칙은 특정 연도의 기준 요일을 이용해,'),
                          Text('어떤 날짜의 요일이든 쉽게 구하는 방법입니다.'),
                          Text('1. 연도의 둠스데이 요일을 구하고,'),
                          Text('2. 월별로 정해진 기준일을 찾은 뒤,'),
                          Text('3. 기준일과 목표 날짜의 차이에 따라 요일을 이동하면 됩니다.'),
                          // 입력 연도	year	int	예: 2025
                          // 입력 월	month	int	예: 6
                          // 입력 일자	date	int	예: 9
                          // 연도의 둠스데이 요일	doomsdayOfYear	int (0~6) 또는 enum	0=일요일, …, 6=토요일
                          // 월별 기준일(둠스데이트)	doomsdateOfMonth	int	예: 6 (6월 6일의 6)
                          // 기준일의 요일	doomsdayOfMonth	동일	doomsdayOfYear와 동일
                          // 날짜 차이	offsetDays	int	date - doomsdateOfMonth
                          // 최종 요일	resultWeekday	int	(doomsdayOfYear + offsetDays) % 7
                          Text(''),
                          Text('\$year년의 \$doomsdayOfYear은?'),
                          Text('\$month월의 \$doomsdateOfMonth은?'),
                          Text('\$month월의 \$doomsdateOfMonth일과 \$date일의 차이는?'),
                          Text('그렇다면 \$resultWeekday은?'),
                        ],
                      ),
                      actions: <Widget>[
                        // TextButton(
                        //   onPressed: () => Navigator.pop(context, 'Cancel'),
                        //   child: const Text('Cancel'),
                        // ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  child: Text('힌트 보기'), // 치트시트 팝업
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => MainPage(title: 'hi'),
                    //     fullscreenDialog: true
                    //   ),
                    // );
                  },
                  child: Text('다시 학습하기'), // 페이지 이동
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
