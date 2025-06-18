import 'package:flutter/material.dart';
import 'package:tour_gangwon_app/widgets/menu_bar.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('마이페이지')),
      body: const Center(
        child: Text('마이페이지입니다.', style: TextStyle(fontSize: 20)),
      ),
      bottomNavigationBar: const MessageWthLink(),
    );
  }
}
