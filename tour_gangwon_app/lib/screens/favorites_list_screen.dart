import 'package:flutter/material.dart';
import 'package:tour_gangwon_app/widgets/common_list_view.dart';

class FavoritesListScreen extends StatelessWidget {
  const FavoritesListScreen({super.key});

  // Dummy data for favorites
  final List<Map<String, String>> _favorites = const [
    {
      'title': '즐겨찾기 1: 오죽헌',
      'description': '신사임당과 율곡 이이가 태어난 유서 깊은 장소입니다. 한국 전통 건축의 아름다움을 느낄 수 있습니다.',
    },
    {
      'title': '즐겨찾기 2: 남이섬',
      'description': '아름다운 자연 경관과 다양한 문화 예술 콘텐츠를 즐길 수 있는 섬입니다. 드라마 촬영지로도 유명합니다.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CommonListView(
          items: _favorites,
          listTitle: '나의 즐겨찾기 목록:',
          // Date is not applicable for favorites, so it's omitted.
        ),
      ),
    );
  }
} 