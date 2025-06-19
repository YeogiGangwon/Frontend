import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../constants/app_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // 2초 대기 (스플래시 화면 표시)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      if (AppConfig.enableAutoLogin) {
        // 개발 모드: 자동 로그인 활성화
        await ApiClient.ensureDevLogin();
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // 프로덕션 모드: 토큰 확인 후 적절한 화면으로 이동
        final hasToken = await ApiClient.hasToken();
        if (hasToken) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      print('Auth check error: $e');
      // 에러 발생 시 개발 모드에서는 홈으로, 프로덕션에서는 로그인으로
      if (AppConfig.enableAutoLogin) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F6),
      body: Center(
        child: Container(
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
    );
  }
}
