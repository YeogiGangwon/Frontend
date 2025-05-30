import 'package:flutter/material.dart';

class RecommendationDetailScreen extends StatelessWidget {
  final String itemTitle; // 이전 화면에서 전달받을 항목 제목
  final String itemDescription; // 이전 화면에서 전달받을 항목 설명 (임시)

  const RecommendationDetailScreen({
    super.key,
    required this.itemTitle,
    required this.itemDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemTitle), // 앱바 제목을 항목 제목으로 설정
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              itemTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // TODO: 여기에 실제 항목 이미지를 표시할 수 있습니다.
            // 예: Image.network('항목_이미지_URL') 또는 Image.asset('assets/항목_이미지.png')
            Container(
              height: 200,
              color: Colors.grey[300], // 임시 이미지 플레이스홀더
              alignment: Alignment.center,
              child: const Text('항목 이미지', style: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 20),
            const Text(
              '상세 정보:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              itemDescription, // 임시 설명
              style: const TextStyle(fontSize: 16),
            ),
            // TODO: 여기에 더 많은 상세 정보를 추가할 수 있습니다.
            // 예: 운영 시간, 주소, 연락처 등
          ],
        ),
      ),
    );
  }
} 