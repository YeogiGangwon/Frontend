import 'package:flutter/material.dart';
import 'package:tour_gangwon_app/widgets/custom_home_app_bar.dart';
import 'package:tour_gangwon_app/widgets/home_banner_carousel.dart';
import 'package:tour_gangwon_app/widgets/category_grid.dart';
import 'package:tour_gangwon_app/widgets/news_card_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = '제주';

  final List<Map<String, String>> _banners = [
    {
      'image': 'assets/images/banner1.jpg',
      'title': '함께 가고 싶은 데이트 맛집',
      'subtitle': '초여름, 연인을 위한 제안',
    },
    {
      'image': 'assets/images/banner2.jpg',
      'title': '6월의 핫플',
      'subtitle': '지금 가장 인기있는 장소',
    },
  ];

  List<CategoryItem> get _categoryItems => [
    CategoryItem(icon: Icons.local_bar, label: '여행지 추천', onTap: () {}),
    CategoryItem(icon: Icons.place, label: '랜덤 여행', onTap: () {}),
    CategoryItem(icon: Icons.favorite, label: '코스 계획하기', onTap: () {}),
    CategoryItem(icon: Icons.liquor, label: '여긴 뭐 쓰지..', onTap: () {}),
  ];

  final List<String> _newsList = [
    '뉴스1',
    '뉴스2',
    '뉴스3',
    '뉴스4',
    '뉴스5',
    '뉴스6',
    '뉴스7',
    '뉴스8',
    '뉴스9',
    '뉴스10'
  ];

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
        onSearch: () {},
        onBookmark: () {},
        onNotification: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeBannerCarousel(banners: _banners),
            const SizedBox(height: 18),
            CategoryGrid(items: _categoryItems),
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
        onTap: (index) {},
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
} 