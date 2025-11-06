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
                ElevatedButton(
                  onPressed: () {},
                  child: Text('힌트 보기'), // 치트시트 팝업
                ),
                ElevatedButton(
                  onPressed: () {},
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
