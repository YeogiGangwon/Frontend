import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchResultListScreen extends StatelessWidget {
  final DateTime date;

  const SearchResultListScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy.MM.dd').format(date);

    final List<Map<String, String>> places = [
      {
        'name': '속초 해수욕장',
        'score': '78',
        'weather': '맑음',
        'distance': '3.2km',
      },
      {
        'name': '경포대',
        'score': '82',
        'weather': '흐림',
        'distance': '5.1km',
      },
      {
        'name': '춘천 남이섬',
        'score': '75',
        'weather': '맑음',
        'distance': '12.4km',
      },
      {
        'name': '설악산 국립공원',
        'score': '90',
        'weather': '비',
        'distance': '1.8km',
      },
      {
        'name': '양양 죽도해변',
        'score': '85',
        'weather': '맑음',
        'distance': '2.0km',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F6),
      body: Column(
        children: [
          // 상단바
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

          // 날짜
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

          // 추천 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return Container(
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
                            Text(
                              '혼잡도 점수: ${place['score']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF49454F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              place['name']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1D1B20),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '날씨: ${place['weather']}   거리: ${place['distance']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF49454F),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/recommendation_detail',
                            arguments: place['name'],
                          );
                        },
                      ),
                    ],
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
