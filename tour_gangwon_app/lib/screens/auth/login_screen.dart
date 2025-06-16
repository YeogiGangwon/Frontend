import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    final pwController = TextEditingController();

    return Scaffold(
      body: ListView(
         padding: EdgeInsets.only(
    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
  ),
        children: [
          Container(
            width: double.infinity,
            height: 884,
            padding: const EdgeInsets.only(top: 116, left: 72, right: 72, bottom: 100),
            decoration: const BoxDecoration(color: Color(0xFFF3F5F6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고
                Container(
                  width: 157,
                  height: 157,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 입력폼 박스
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF3F5F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: [
                      // ID 라벨
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'ID',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1E1E1E),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ID 입력창
                      TextField(
                        controller: idController,
                        decoration: InputDecoration(
                          hintText: '아이디를 입력하세요',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF002C50), width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // PW 라벨
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1E1E1E),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // PW 입력창
                      TextField(
                        controller: pwController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '비밀번호를 입력하세요',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF002C50), width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 로그인 버튼
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            print('ID: ${idController.text}');
                            print('PW: ${pwController.text}');
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF002C50),
                            foregroundColor: Colors.white,                // ✅ 텍스트 색 명시!
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
          'Sign In',
  style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 회원가입/비번찾기
                      Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/signup'); // 회원가입 화면 이동
      },
      child: const Text(
        '회원가입',
        style: TextStyle(
          decoration: TextDecoration.underline,
          fontSize: 16,
          color: Color(0xFF1E1E1E),
        ),
      ),
    ),
    const SizedBox(width: 22),
    TextButton(
      onPressed: () {
        // TODO: 비밀번호 찾기 화면 연결할 거면 여기에 추가
        print('비밀번호 찾기 클릭됨');
      },
      child: const Text(
        '비밀번호 찾기',
        style: TextStyle(
          decoration: TextDecoration.underline,
          fontSize: 16,
          color: Color(0xFF1E1E1E),
        ),
      ),
    ),
  ],
),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
