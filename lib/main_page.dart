import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            TextFieldWithTitleWidget(title: "닉네임"),
            const SizedBox(
              height: 20,
            ),
            TextFieldWithTitleWidget(title: "가수"),
            const SizedBox(
              height: 20,
            ),
            TextFieldWithTitleWidget(title: "노래제목"),
            const Spacer(),
            GestureDetector(
              onTap: () {
                _showSystemAlert(context);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 70, 157, 80),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "제출하기",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

  // 시스템 알림 다이얼로그를 띄우는 함수
  void _showSystemAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('제출하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class TextFieldWithTitleWidget extends StatelessWidget {
  final String title;
  const TextFieldWithTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
            ),
          ],
        ),
        TextField(),
      ],
    );
  }
}
