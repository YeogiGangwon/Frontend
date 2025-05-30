import 'package:flutter/material.dart';

class RecommendationListScreen extends StatelessWidget {
  final DateTime? date; // 날짜 선택 화면으로부터 전달받을 날짜

  const RecommendationListScreen({super.key, this.date});

  // 임시 데이터 모델
  final List<Map<String, String>> _recommendations = const [
    {
      'title': '추천 항목 1',
      'description': '추천 항목 1에 대한 아주 상세한 설명입니다. 이 설명은 여러 줄에 걸쳐 표시될 수 있으며, 사용자가 항목에 대해 더 잘 이해하도록 돕습니다.',
    },
    {
      'title': '추천 항목 2',
      'description': '추천 항목 2는 매우 특별한 경험을 제공합니다. 관련된 역사적 배경이나 문화적 중요성에 대해 알아볼 수 있습니다.',
    },
    {
      'title': '추천 항목 3',
      'description': '추천 항목 3을 방문하면 잊지 못할 추억을 만들 수 있습니다. 주변 경관도 매우 아름답습니다.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('추천 리스트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (date != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  '선택된 날짜: ${date!.toLocal()}'.split(' ')[0],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  '날짜 정보 없음',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
            Text(
              date != null ? '${date!.month}월 ${date!.day}일 추천 항목:' : '오늘의 추천 항목:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _recommendations.length,
                itemBuilder: (context, index) {
                  final item = _recommendations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: const Icon(Icons.star, color: Colors.amber),
                      title: Text(item['title']!),
                      subtitle: Text(
                        item['description']!,
                        maxLines: 2, // 설명을 두 줄까지만 표시
                        overflow: TextOverflow.ellipsis, // 넘어가는 텍스트는 ...으로 표시
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 