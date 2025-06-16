import 'package:flutter/material.dart';
import 'package:tour_gangwon_app/services/photo_api_service.dart';
import 'package:tour_gangwon_app/models/photo_model.dart';
import 'package:tour_gangwon_app/screens/recommendation_list_screen.dart';
import 'package:tour_gangwon_app/screens/date_selection_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Photo>> _bannersFuture;

  final List<Map<String, String>> _categoryItems = [
    {
      'title': '무계획 여행 떠나기',
      'subtitle': '여행지를 랜덤으로 추천',
      'image': 'assets/images/plane.png'
    },
    {
      'title': '혼잡도 여행지 추천',
      'subtitle': '혼잡도에 맞춰 여행지를 추천',
      'image': 'assets/images/plane.png'
    },
    {
      'title': '풀 코스 여행 계획',
      'subtitle': '코스를 짜주는 서비스',
      'image': 'assets/images/plane.png'
    },
  ];

  final List<Map<String, String>> _todayInfoItems = List.generate(
    5,
    (index) => {
      'title': 'List item',
      'desc': 'Supporting line text lorem ipsum dolor sit amet, consectetur.',
      'image': 'https://placehold.co/56x56'
    },
  );

  @override
  void initState() {
    super.initState();
    _bannersFuture = PhotoApiService().fetchPhotos(numOfRows: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: const [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('마이페이지'),
            ),
            ListTile(
              leading: Icon(Icons.star_border),
              title: Text('즐겨찾기'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('로그아웃'),
            ),
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
                Image.asset(
                  'assets/images/logo.png',
                  width: 32,
                  height: 32,
                ),
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
                )
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: ListView(
          children: [
            FutureBuilder<List<Photo>>(
              future: _bannersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('배너 없음');
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 205,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data![0].webImageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 56,
                        height: 205,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          image: const DecorationImage(
                            image: NetworkImage('https://placehold.co/56x205'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
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
              builder: (_) => SearchResultListScreen(date: selectedDate),
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
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}