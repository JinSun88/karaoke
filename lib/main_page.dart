import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController singerController = TextEditingController();
  final TextEditingController songTitleController = TextEditingController();
  final TextEditingController requestController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              TextFieldWithTitleWidget(
                title: "닉네임(필수)",
                controller: nicknameController,
                hint: "ex) 금개",
              ),
              const SizedBox(height: 20),
              TextFieldWithTitleWidget(
                title: "가수(필수)",
                controller: singerController,
                hint: "ex) 체리필터",
              ),
              const SizedBox(height: 20),
              TextFieldWithTitleWidget(
                title: "노래제목(필수)",
                controller: songTitleController,
                hint: "ex) 오리날다",
              ),
              const SizedBox(height: 20),
              TextFieldWithTitleWidget(
                title: "요청사항(선택)",
                controller: requestController,
                hint: "ex) 2키 낮춰주세요.",
              ),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  _onSubmit(context);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 70, 157, 80),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "제출하기",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (nicknameController.text.isEmpty ||
        singerController.text.isEmpty ||
        songTitleController.text.isEmpty) {
      // 필드 중 하나라도 비어 있으면 경고 표시
      _showErrorAlert(context);
    } else {
      // 모든 필드가 입력되었으면 확인 알림 표시
      _showSubmitAlert(context);
    }
  }

  void _showErrorAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text(''),
          content: const Text('필수 사항을 입력해주세요.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 시스템 알림 다이얼로그를 띄우는 함수
  void _showSubmitAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text(''),
          content: const Text('제출하시겠습니까?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('확인'),
              onPressed: () {
                // Firestore에 데이터 추가
                _getOrder().then((order) => _addDataToFirestore(order));

                // 다이얼로그 닫기
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addDataToFirestore(int order) async {
    try {
      await _firestore.collection('reservation').add({
        'nickname': nicknameController.text,
        'singer': singerController.text,
        'songTitle': songTitleController.text,
        'request': requestController.text,
        'order': order,
      });
      // 입력된 텍스트 필드 초기화
      nicknameController.text = "";
      singerController.text = "";
      songTitleController.text = "";
      requestController.text = "";
    } catch (e) {
      print(e);
    }
  }

  Future<int> _getOrder() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('reservation')
          .orderBy('order', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return 0;
      } else {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return data['order'] + 1;
      }
    } catch (e) {
      print("Error fetching order: $e");
      return 0;
    }
  }
}

class TextFieldWithTitleWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String hint;

  const TextFieldWithTitleWidget({
    super.key,
    required this.title,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
