import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  Future<void> _linkKakaoAccount(BuildContext context) async {
    // TODO: 카카오계정 연동 로직 구현
    print('카카오계정 연동하기 버튼 클릭됨');
    // 성공 시 알림 또는 다음 단계로 이동
  }

  Future<void> _selectTravelPreference(BuildContext context, String preference) async {
    // TODO: 여행 취향 선택 로직 구현
    print('\$preference 선택됨');
  }

  Future<void> _completeSignup(BuildContext context) async {
    // TODO: 회원가입 완료 로직 구현
    // 성공 시 홈 화면 또는 로그인 화면으로 이동
    print('회원가입 완료 버튼 클릭됨');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); // 로그인 화면으로 이동 후 이전 스택 모두 제거
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => _linkKakaoAccount(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble, color: Colors.black87), // 임시 카카오 아이콘
                      SizedBox(width: 10),
                      Text('카카오계정 연동하기', style: TextStyle(color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                const Text(
                  '어떤 여행을 즐기시나요?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _selectTravelPreference(context, '액티비티'),
                  child: const Text('액티비티 중심'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _selectTravelPreference(context, '휴식'),
                  child: const Text('여유로운 휴식'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _selectTravelPreference(context, '맛집탐방'),
                  child: const Text('맛집 탐방'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _completeSignup(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              child: const Text('회원가입 완료'),
            ),
          ],
        ),
      ),
    );
  }
} 