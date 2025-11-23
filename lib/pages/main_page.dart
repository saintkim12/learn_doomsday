import 'package:flutter/material.dart';
import 'package:learn_doomsday/widgets/big_button.dart';
import 'package:learn_doomsday/pages/quiz_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BigButton(
              label: '연습하기',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const QuizPage(),
                  ),
                );
              },
            ),
            BigButton(label: '오늘의 역사'),
            BigButton(label: '다시 배우기'),
          ],
        ),
      ),
    );
  }
}
