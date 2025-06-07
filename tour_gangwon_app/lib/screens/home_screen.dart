// tour_gangwon_app/lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:tour_gangwon_app/widgets/custom_home_app_bar.dart';
import 'package:tour_gangwon_app/widgets/home_banner_carousel.dart';
import 'package:tour_gangwon_app/widgets/category_grid.dart';
import 'package:tour_gangwon_app/widgets/news_card_list.dart';
import 'package:tour_gangwon_app/services/photo_api_service.dart'; // 추가
import 'package:tour_gangwon_app/models/photo_model.dart'; // 추가
import 'package:tour_gangwon_app/widgets/notification_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = '강원도'; // 초기 위치를 강원도로 변경 (더 적합하게)

  late Future<List<Photo>> _photosFuture; // 추가
  late Future<List<Photo>> _bannersFuture;

  List<CategoryItem> get _categoryItems => [
    CategoryItem(icon: Icons.local_bar, label: '여행지 추천', onTap: () {}),
    CategoryItem(icon: Icons.place, label: '랜덤 여행', onTap: () {}),
    CategoryItem(icon: Icons.favorite, label: '코스 계획하기', onTap: () {}),
    CategoryItem(icon: Icons.liquor, label: '여긴 뭐 쓰지..', onTap: () {}),
  ];

  final List<String> _newsList = [
    '뉴스1', '뉴스2', '뉴스3', '뉴스4', '뉴스5',
    '뉴스6', '뉴스7', '뉴스8', '뉴스9', '뉴스10'
  ];

  @override
  void initState() {
    super.initState();
    _bannersFuture = PhotoApiService().fetchPhotos(numOfRows: 10, keyword: '강원');
    _photosFuture = PhotoApiService().fetchPhotos(numOfRows: 20); // 기존 사진 섹션용
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHomeAppBar(
        location: _selectedLocation,
        searchController: _searchController,
        hasNotification: true,
        onLocationTap: () {},
        onSearch: () {
          Navigator.pushNamed(context, '/search_result_list'); // 검색 결과 화면으로 이동
        },
        onBookmark: () {
          Navigator.pushNamed(context, '/favorites_list'); // 즐겨찾기 화면으로 이동 (추가 필요)
        },
        onNotification: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const NotificationPopup(); // 알림 팝업 표시
            },
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Photo>>(
              future: _bannersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 180,
                    child: Center(child: Text('배너를 불러오지 못했습니다: \\${snapshot.error}')),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: Text('표시할 배너가 없습니다.')),
                  );
                } else {
                  final banners = snapshot.data!
                      .map((photo) => {
                            'image': photo.webImageUrl,
                            'title': photo.title,
                            'subtitle': photo.photographer,
                          })
                      .toList();
                  return HomeBannerCarousel(banners: banners);
                }
              },
            ),
            const SizedBox(height: 18),
            CategoryGrid(items: _categoryItems),
            const SizedBox(height: 18),
            const Text(
              '한국관광공사 추천 사진', // 새로운 섹션 제목
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // API에서 가져온 사진을 표시할 FutureBuilder
            FutureBuilder<List<Photo>>(
              future: _photosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('사진을 불러오는 데 실패했습니다: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('표시할 사진이 없습니다.'));
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 한 줄에 2개의 이미지
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.8, // 이미지와 텍스트를 고려한 비율
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final photo = snapshot.data![index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.network(
                                photo.webImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    photo.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '작가: ${photo.photographer}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 18),
            NewsCardList(newsList: _newsList),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: '내 주변'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '마이다이닝'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MY'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // TODO: 각 탭에 맞는 화면으로 이동 로직 구현
          if (index == 3) { // MY 탭 (index 3) 클릭 시 마이페이지로 이동
            Navigator.pushNamed(context, '/mypage');
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor, // 선택된 아이템 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
      ),
    );
  }
}