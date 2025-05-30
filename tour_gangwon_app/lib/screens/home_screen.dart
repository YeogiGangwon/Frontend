import 'package:flutter/material.dart';
import 'package:tour_gangwon_app/widgets/notification_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 임시 추천 랭킹 데이터 (강원도 관광지)
  final List<Map<String, String>> _rankingData = const [
    {
      'rank': '1',
      'title': '설악산 국립공원',
      'description': '웅장한 산세와 아름다운 계곡을 자랑하는 대한민국 대표 명산입니다. 사계절 다채로운 풍경을 선사합니다.',
      'image': 'assets/images/seoraksan.jpg', // TODO: 실제 이미지 경로 또는 URL로 변경
    },
    {
      'rank': '2',
      'title': '남이섬',
      'description': '북한강에 떠 있는 아름다운 섬으로, 드라마 촬영지로도 유명합니다. 메타세쿼이아길이 특히 아름답습니다.',
      'image': 'assets/images/namisum.jpg', // TODO: 실제 이미지 경로 또는 URL로 변경
    },
    {
      'rank': '3',
      'title': '강릉 경포호',
      'description': '봄에는 벚꽃, 여름에는 해수욕, 겨울에는 철새를 볼 수 있는 사계절 관광지입니다. 관동팔경 중 하나입니다.',
      'image': 'assets/images/gyeongpoho.jpg', // TODO: 실제 이미지 경로 또는 URL로 변경
    },
  ];

  // 임시 관련 뉴스 데이터
  final List<Map<String, String>> _newsData = const [
    {
      'title': '강원도, 여름 휴가철 맞이 관광객 유치 총력',
      'source': '강원일보 - 2023.07.15',
      'url': '' // TODO: 실제 뉴스 URL 추가
    },
    {
      'title': '평창송어축제, 겨울 대표 축제로 자리매김',
      'source': '연합뉴스 - 2023.12.20',
      'url': '' // TODO: 실제 뉴스 URL 추가
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('투어 강원'),
        // automaticallyImplyLeading: false, // Remove or set to true to allow Drawer icon
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined), // Bell icon
            tooltip: '알림',
            onPressed: () {
              // Show notification popup
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const NotificationPopup();
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: '마이페이지',
            onPressed: () {
              Navigator.pushNamed(context, '/mypage');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                '메뉴',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '검색...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        // TODO: Implement search logic
                        print('Search query: $value');
                        if (value == '검색') {
                          Navigator.pop(context); // Close the drawer
                          Navigator.pushNamed(context, '/search_result_list');
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (_searchController.text == '검색') {
                        Navigator.pop(context); // Close the drawer
                        Navigator.pushNamed(context, '/search_result_list');
                      }
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('홈'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Optionally, navigate to home if not already there or refresh
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border_outlined),
              title: const Text('즐겨찾기'),
              onTap: () {
                // TODO: 즐겨찾기 화면으로 이동 또는 즐겨찾기 목록 표시
                Navigator.pop(context); // Close the drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('즐겨찾기 기능 준비 중입니다.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('설정'),
              onTap: () {
                // TODO: 설정 화면으로 이동 또는 설정 기능 구현
                Navigator.pop(context); // Close the drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('설정 기능 준비 중입니다.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('로그아웃'),
              onTap: () {
                // TODO: 로그아웃 로직 구현
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
            // Add more ListTiles for other sidebar items
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- 추천 랭킹 섹션 ---
            const Text(
              '강원도 추천 랭킹 TOP 3',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250, // Carousel height
              child: PageView.builder(
                itemCount: _rankingData.length,
                itemBuilder: (context, index) {
                  final item = _rankingData[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/recommendation_detail',
                        arguments: {
                          'title': item['title']!,
                          'description': item['description']!,
                          // 'image': item['image']!, // Pass image if detail screen uses it
                        },
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      clipBehavior: Clip.antiAlias, // Ensures the image respects card rounded corners
                      child: Stack(
                        fit: StackFit.expand, // Makes the Stack fill the Card
                        children: <Widget>[
                          // Background Image
                          Image.asset(
                            item['image']!,
                            fit: BoxFit.cover,
                            // Error handling for image loading (optional but good practice)
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              );
                            },
                          ),
                          // Title Overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Text(
                                item['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          // Rank Number (Optional, styled at top-left)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '#${item['rank']!}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // --- 추천 생성 버튼들 ---
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/date_selection');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('나만의 추천 생성'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      if (_rankingData.isNotEmpty) {
                        final randomIndex = DateTime.now().millisecond % _rankingData.length;
                        final randomItem = _rankingData[randomIndex];
                        Navigator.pushNamed(
                          context,
                          '/recommendation_detail',
                          arguments: {
                            'title': randomItem['title']!,
                            'description': randomItem['description']!,
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('추천할 항목이 없습니다.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('랜덤 추천 생성'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- 관련 뉴스 섹션 ---
            const Text(
              '강원도 관광 뉴스',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _newsData.length,
              itemBuilder: (context, index) {
                final news = _newsData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(news['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(news['source']!),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${news['title']} 뉴스 준비 중입니다.')),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 