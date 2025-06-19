import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/mypage_screen.dart';
import 'screens/date_selection_screen.dart';
import 'screens/search_result_list_screen.dart';
import 'screens/recommendation_detail_screen.dart';
import 'screens/favorites_list_screen.dart';
import 'screens/browse_screen.dart';

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
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/mypage': (context) => const MyPageScreen(),
        '/date_selection': (context) => const DateSelectionScreen(),
        '/favorites_list': (context) => const FavoritesListScreen(),
        '/browse': (context) => const BrowseScreen(),

        // 날짜 기반 추천 리스트로 이동
        '/search_result_list': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final date = args is DateTime ? args : DateTime.now();
          return SearchResultListScreen(date: date);
        },

        // 상세 페이지 이동
        '/recommendation_detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as int;
          return RecommendationDetailScreen(placeId: args);
        },
      },
    );
  }
}
