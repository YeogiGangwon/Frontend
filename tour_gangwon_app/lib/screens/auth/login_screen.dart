import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _loginWithKakao(BuildContext context) async {
    // TODO: 카카오 로그인 로직 구현
    // 성공 시 홈 화면으로 이동
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.flutter_dash, size: 80, color: Colors.blue), // 임시 로고
              const SizedBox(height: 20),
              const Text(
                '처음처럼 떠나는 강원도 여행',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                '쾌적한 여행을 원하는 당신, 지금 처음처럼 떠나보세요',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _loginWithKakao(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // 카카오 색상과 유사하게
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TODO: 카카오 아이콘 추가 (예: Image.asset)
                    Icon(Icons.chat_bubble, color: Colors.black87), // 임시 아이콘
                    SizedBox(width: 10),
                    Text('카카오 로그인', style: TextStyle(color: Colors.black87)),
                  ],
                ),
              ),
              const SizedBox(height: 20), // 로그인 버튼과 회원가입 버튼 사이 간격
              TextButton(
                onPressed: () {
                  // TODO: 회원가입 화면으로 이동 로직 구현
                  print('회원가입 버튼 클릭됨');
                  Navigator.pushNamed(context, '/signup'); // 회원가입 화면으로 이동
                },
                child: const Text(
                  '회원가입',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 