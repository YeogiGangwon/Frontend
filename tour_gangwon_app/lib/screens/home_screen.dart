import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tour_gangwon_app/screens/search_result_list_screen.dart';
import 'package:tour_gangwon_app/screens/date_selection_screen.dart';
import 'package:tour_gangwon_app/widgets/menu_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  final List<Map<String, String>> _categoryItems = [
    {
      'title': '무계획 여행 떠나기',
      'subtitle': '여행지를 랜덤으로 추천',
      'image': 'assets/images/plane.png',
    },
    {
      'title': '혼잡도 여행지 추천',
      'subtitle': '혼잡도에 맞춰 여행지를 추천',
      'image': 'assets/images/plane.png',
    },
    {
      'title': '풀 코스 여행 계획',
      'subtitle': '코스를 짜주는 서비스',
      'image': 'assets/images/plane.png',
    },
  ];

  final List<Map<String, String>> _todayInfoItems = List.generate(
    5,
    (index) => {
      'title': 'List item',
      'desc': 'Supporting line text lorem ipsum dolor sit amet, consectetur.',
      'image': 'https://placehold.co/56x56',
    },
  );

  Future<List<Map<String, dynamic>>> loadPlaces() async {
    final String jsonStr = await rootBundle.loadString(
      'assets/data/places.json',
    );
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: const [
            ListTile(leading: Icon(Icons.person), title: Text('마이페이지')),
            ListTile(leading: Icon(Icons.star_border), title: Text('즐겨찾기')),
            ListTile(leading: Icon(Icons.logout), title: Text('로그아웃')),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: const Color(0xFFF3F5F6),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/logo.png', width: 32, height: 32),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey[300],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/images/notifi.png'),
                      ),
                    ),
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey[300],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset('assets/images/menu.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: ListView(
          children: [
            // 추천 여행지 섹션 (상단, place.json 사용)
            FutureBuilder<List<Map<String, dynamic>>>(
              future: loadPlaces(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 260,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final places = snapshot.data!;
                return Column(
                  children: [
                    SizedBox(
                      height: 260,
                      child: PageView.builder(
                        itemCount: places.length,
                        controller: _pageController,
                        onPageChanged: (idx) {
                          setState(() {
                            _currentPage = idx;
                          });
                        },
                        itemBuilder: (context, idx) {
                          final place = places[idx];
                          final String imagePath =
                              'assets/images/${place['id']}.jpg';
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 8,
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    imagePath,
                                    width: double.infinity,
                                    height: 260,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.25),
                                          Colors.black.withOpacity(0.45),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 18,
                                  top: 18,
                                  right: 18,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        place['name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black54,
                                              blurRadius: 4,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        place['description'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          height: 1.3,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black38,
                                              blurRadius: 2,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 16,
                                  bottom: 16,
                                  child: Text(
                                    'METIZEN',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 1.2,
                                      shadows: const [
                                        Shadow(
                                          color: Colors.black38,
                                          blurRadius: 2,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(places.length, (idx) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == idx
                                ? const Color(0xFF2250FF)
                                : Colors.grey[300],
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            // 나머지 컨텐츠 (카테고리, Today Info 등)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _categoryItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final categoryCard = Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: item['image']!.startsWith('assets')
                                ? AssetImage(item['image']!) as ImageProvider
                                : NetworkImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1D1B20),
                        ),
                      ),
                      Text(
                        item['subtitle']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF49454F),
                        ),
                      ),
                    ],
                  ),
                );

                return Expanded(
                  child: index == 1
                      ? GestureDetector(
                          onTap: () async {
                            final selectedDate = await Navigator.push<DateTime>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DateSelectionScreen(),
                              ),
                            );

                            if (selectedDate != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SearchResultListScreen(
                                    date: selectedDate,
                                  ),
                                ),
                              );
                            }
                          },
                          child: categoryCard,
                        )
                      : categoryCard,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              "Today's INFO",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              children: _todayInfoItems.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFCAC4D0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF1D1B20),
                              ),
                            ),
                            Text(
                              item['desc']!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF49454F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MessageWthLink(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
