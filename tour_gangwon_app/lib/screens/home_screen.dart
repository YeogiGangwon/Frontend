import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tour_gangwon_app/screens/search_result_list_screen.dart';
import 'package:tour_gangwon_app/screens/date_selection_screen.dart';
import 'package:tour_gangwon_app/screens/recommendation_detail_screen.dart';
import 'package:tour_gangwon_app/screens/beach_list_screen.dart';
import 'package:tour_gangwon_app/screens/beach_detail_screen.dart';
import 'package:tour_gangwon_app/services/beach_service.dart';
import 'package:tour_gangwon_app/widgets/news_card_list.dart';
import 'package:tour_gangwon_app/constants/colors.dart';
import 'package:tour_gangwon_app/models/festival_model.dart';
import 'package:tour_gangwon_app/services/api_client.dart';

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
      'title': '랜덤 추천',
      'subtitle': '무계획으로 떠나는 여행',
      'image': 'assets/images/random.png',
    },
    {
      'title': '여행지 추천',
      'subtitle': '최적의 여행지 추천',
      'image': 'assets/images/travel.png',
    },
    {
      'title': '코스 추천',
      'subtitle': '완벽한 계획, 완벽한 여행',
      'image': 'assets/images/route.png',
    },
  ];

  final List<FestivalCard> _festivalList = [
    FestivalCard(
      name: '무릉별유천지 라벤더 축제',
      period: '2025.6.14 - 6.22',
      imageUrl: 'assets/images/festival_lavender.png',
      location: '동해시 무릉별유천지 일원',
    ),
    FestivalCard(
      name: '횡성 썸머나잇페스타',
      period: '2025.6.20 - 6.21',
      imageUrl: 'assets/images/summer.jpg',
      location: '횡성군 섬강 일원',
    ),
    FestivalCard(
      name: '산맥 페스티벌',
      period: '2025.6.13 - 6.14',
      imageUrl: 'assets/images/beer.png',
      location: '정선군 두위봉 일원',
    ),
    FestivalCard(
      name: '실향민문화축제',
      period: '2025.6.13 - 6.15',
      imageUrl: 'assets/images/culture.png',
      location: '속초 엑스포 잔디광장 일원',
    ),
  ];

  Future<List<Map<String, dynamic>>> loadPlaces() async {
    try {
      final String jsonStr = await rootBundle.loadString(
        'assets/data/places.json',
      );
      final List<dynamic> jsonList = json.decode(jsonStr);
      return jsonList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error loading places.json: $e');
      // Fallback 데이터 반환
      return [
        {
          'id': '1',
          'name': '강릉 경포해수욕장',
          'description': '넓은 백사장과 다양한 편의시설이 잘 갖춰진 대표적인 강릉 해수욕장',
        },
        {
          'id': '2',
          'name': '속초 해수욕장',
          'description': '설악산과 바다를 동시에 즐길 수 있는 아름다운 해수욕장',
        },
        {
          'id': '3',
          'name': '양양 낙산해수욕장',
          'description': '낙산사와 인접한 고즈넉한 분위기의 해수욕장',
        },
      ];
    }
  }

  IconData _getCategoryIcon(int index) {
    switch (index) {
      case 0: // 랜덤 추천
        return Icons.shuffle;
      case 1: // 여행지 추천
        return Icons.travel_explore;
      case 2: // 코스 추천
        return Icons.route;
      default:
        return Icons.place;
    }
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            // 상단 헤더
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '여기강원',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '강원도 여행의 모든 것',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            // 메뉴 항목들
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildDrawerItem(
                    icon: Icons.home,
                    title: '홈',
                    onTap: () {
                      Navigator.pop(context);
                      // 이미 홈 화면이므로 아무것도 하지 않음
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.search,
                    title: '찾아보기',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/browse');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.favorite,
                    title: '즐겨찾기',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/favorites_list');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.person,
                    title: '마이페이지',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/mypage');
                    },
                  ),
                  const Divider(height: 40),
                  _buildDrawerItem(
                    icon: Icons.logout,
                    title: '로그아웃',
                    onTap: () async {
                      Navigator.pop(context);
                      await ApiClient.removeToken();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 좌측 메뉴 버튼
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
                        color: AppColors.surface,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/menu.png',
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.menu,
                              color: AppColors.textSecondary,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // 중앙 타이틀
                const Text(
                  '여기강원',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                // 우측 알림 버튼
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/images/notifi.png',
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.notifications,
                          color: AppColors.textSecondary,
                        );
                      },
                    ),
                  ),
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
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        height: 260,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppColors.primaryLight,
                                              AppColors.primary,
                                            ],
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.landscape,
                                            size: 64,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
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
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            // 추천 카테고리 섹션 (하나의 컨테이너에 세 개 버튼)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _categoryItems
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final categoryButton = Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Image.asset(
                              item['image']!,
                              fit: BoxFit.contain,
                              width: 48,
                              height: 48,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  _getCategoryIcon(index),
                                  size: 32,
                                  color: AppColors.primary,
                                );
                              },
                              color: AppColors.primary, // 이미지도 붉은색으로 tint
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['title']!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          SizedBox(
                            width: 80,
                            child: Text(
                              item['subtitle']!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );

                      final buttonWithDivider = <Widget>[];

                      buttonWithDivider.add(
                        GestureDetector(
                          onTap: () async {
                            if (index == 0) {
                              // 랜덤 추천 - 해수욕장 중 랜덤 선택
                              try {
                                await BeachService.loadBeaches();
                                final beaches = BeachService.getAllBeaches();
                                if (beaches.isNotEmpty) {
                                  final random = Random();
                                  final randomBeach =
                                      beaches[random.nextInt(beaches.length)];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BeachDetailScreen(
                                        beachId: randomBeach.id,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text('해수욕장 정보를 불러올 수 없습니다.'),
                                        ],
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text('랜덤 추천 중 오류가 발생했습니다.'),
                                      ],
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              }
                            } else if (index == 1) {
                              // 여행지 추천 - 날짜 선택 화면으로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DateSelectionScreen(),
                                ),
                              );
                            } else if (index == 2) {
                              // 코스 추천
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text('코스 추천 기능은 제작 예정입니다.'),
                                    ],
                                  ),
                                  backgroundColor: AppColors.primary,
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }
                          },
                          child: categoryButton,
                        ),
                      );

                      // 마지막 버튼이 아니면 구분선 추가
                      if (index < _categoryItems.length - 1) {
                        buttonWithDivider.add(
                          Container(
                            width: 1,
                            height: 80,
                            color: AppColors.divider,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        );
                      }

                      return buttonWithDivider;
                    })
                    .expand((x) => x)
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "NOW 강원",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            NewsCardList(festivalList: _festivalList),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
