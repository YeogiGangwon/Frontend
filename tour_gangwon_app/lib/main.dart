// tour_gangwon_app/lib/main.dart
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/mypage_screen.dart';
import 'screens/date_selection_screen.dart';
import 'screens/recommendation_list_screen.dart'; // 이전에 있던 것과 이름 충돌에 주의
import 'screens/recommendation_detail_screen.dart';
import 'screens/search_result_list_screen.dart';
import 'screens/favorites_list_screen.dart'; // 추가

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recommendation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/', // 초기 화면은 스플래시 화면
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/mypage': (context) => const MyPageScreen(),
        '/date_selection': (context) => const DateSelectionScreen(),
        '/recommendations': (context) => RecommendationListScreen(date: ModalRoute.of(context)!.settings.arguments as DateTime?),
        '/recommendation_detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return RecommendationDetailScreen(
            itemTitle: args['title']!,
            itemDescription: args['description']!,
          );
        },
        '/search_result_list': (context) => const SearchResultListScreen(),
        '/favorites_list': (context) => const FavoritesListScreen(), // 추가
      },
    );
  }
}