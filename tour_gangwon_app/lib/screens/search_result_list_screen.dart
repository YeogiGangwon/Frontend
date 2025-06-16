// lib/screens/search_result_list_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchResultListScreen extends StatelessWidget {
  final DateTime date;

  const SearchResultListScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy.MM.dd').format(date);

    // 더미 여행지 목록
    final List<Map<String, String>> recommendations = [
      {
        'title': '속초 해수욕장',
        'description': '맑은 날씨와 쾌적한 분위기의 속초 대표 해변입니다.',
      },
      {
        'title': '경포대',
        'description': '아름다운 호수와 해변을 동시에 즐길 수 있는 명소입니다.',
      },
      {
        'title': '주문진 수산시장',
        'description': '신선한 해산물을 현장에서 맛볼 수 있는 시장입니다.',
      },
      {
        'title': '낙산사',
        'description': '조용한 산사에서 마음의 평화를 느껴보세요.',
      },
      {
        'title': '설악산 국립공원',
        'description': '등산과 풍경 감상을 동시에 즐길 수 있는 명소입니다.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F6),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 78,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$formattedDate 추천 여행지',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D1B20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final item = recommendations[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/recommendation_detail',
                      arguments: {
                        'title': item['title']!,
                        'description': item['description']!,
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/beach1.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '혼잡도 점수: 78',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF49454F),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['title']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF1D1B20),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '날씨: 맑음   거리: 3.2km',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF49454F),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
