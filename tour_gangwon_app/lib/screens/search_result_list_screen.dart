import 'package:flutter/material.dart';
import 'package:tour_gangwon_app/widgets/common_list_view.dart';

class SearchResultListScreen extends StatelessWidget {
  // In a real app, search query might be passed here
  const SearchResultListScreen({super.key});

  // Dummy data for search results
  final List<Map<String, String>> _searchResults = const [
    {
      'title': '검색 결과 1: 강릉 해변',
      'description': '강릉의 아름다운 해변입니다. 여름철 피서객들에게 인기가 많습니다.',
    },
    {
      'title': '검색 결과 2: 설악산 국립공원',
      'description': '한국의 대표적인 명산, 설악산입니다. 사계절 아름다운 풍경을 자랑합니다.',
    },
    {
      'title': '검색 결과 3: 춘천 명동 닭갈비 골목',
      'description': '춘천의 명물, 닭갈비를 맛볼 수 있는 곳입니다. 다양한 닭갈비 식당이 모여 있습니다.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색 결과'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CommonListView(
          items: _searchResults,
          listTitle: '검색 결과입니다:',
          // Date is not applicable for search results, so it's omitted.
          // CommonListView will not show date related info.
        ),
      ),
    );
  }
} 