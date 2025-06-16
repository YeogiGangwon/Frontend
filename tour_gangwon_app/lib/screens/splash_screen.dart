import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash to Login',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFFF3F5F6),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (c) => const LoginPage(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F6),
      body: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/login'),
        child: SizedBox(
          width: w,
          height: h,
          child: Center(
            child: Container(
              // 로고 배경 회색 박스만 남김
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: const Color(0xFFA2A7AE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Image.asset(
                'assets/images/splash_logo.png',
                width: 137,
                height: 136,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: const Center(
        child: Text('로그인 화면'),
      ),
    );
  }
}
