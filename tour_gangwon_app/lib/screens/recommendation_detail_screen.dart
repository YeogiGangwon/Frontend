import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../services/place_service.dart';
import '../widgets/menu_bar.dart';

class RecommendationDetailScreen extends StatefulWidget {
  final int placeId;

  const RecommendationDetailScreen({super.key, required this.placeId});

  @override
  State<RecommendationDetailScreen> createState() =>
      _RecommendationDetailScreenState();
}

class _RecommendationDetailScreenState
    extends State<RecommendationDetailScreen> {
  Place? place;
  bool isLoading = true;
  int congestionLevel = 78; // 예시 혼잡도 수치
  bool isFavorite = false; // 즐겨찾기 상태

  @override
  void initState() {
    super.initState();
    _loadPlace();
  }

  Future<void> _loadPlace() async {
    try {
      await PlaceService.loadPlaces(); // 캐시에 데이터 로드
      final loadedPlace = PlaceService.getPlaceById(widget.placeId);
      setState(() {
        place = loadedPlace;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading place: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF3F5F6),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (place == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF3F5F6),
        body: Center(child: Text('장소 정보를 찾을 수 없습니다.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F6),
      body: ListView(
        children: [
          // 이미지 및 상단 타이틀
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 412,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(place!.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
              ),
              Container(
                height: 412,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
              // 뒤로가기 버튼
              Positioned(
                top: 50,
                left: 16,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
              // 좌측 하단 관광지 이름
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  place!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              // 우측 하단 3개 아이콘
              Positioned(
                right: 16,
                bottom: 16,
                child: Row(
                  children: [
                    _buildStatusIcon(),
                    const SizedBox(width: 8),
                    _buildWeatherIcon(),
                    const SizedBox(width: 8),
                    _buildMapIcon(),
                  ],
                ),
              ),
            ],
          ),

          // 상세 설명
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F5F6),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 위치 정보와 즐겨찾기 버튼
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 위치 정보 (더 크고 명확하게)
                          Text(
                            place!.location,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D1B20),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // 해시태그들 (스타일 개선)
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: place!.tags
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8DEF8),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF65558F,
                                        ).withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '#$tag',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF65558F),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 즐겨찾기 버튼
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                        // TODO: 즐겨찾기 저장/삭제 기능 구현
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isFavorite
                              ? const Color(0xFFFFE8E8)
                              : const Color(0xFFF3F5F6),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: isFavorite
                                ? Colors.red.withOpacity(0.3)
                                : const Color(0xFFCAC4D0),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.red
                              : const Color(0xFF49454F),
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '상세 설명',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1B20),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  place!.explain,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1D1B20),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // 후기 보기 버튼
          Container(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () {
                // TODO: 후기 보기 동작
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                side: const BorderSide(color: Color(0xFF79747E)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                '후기 보기',
                style: TextStyle(
                  color: Color(0xFF65558F),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const MessageWthLink(),
    );
  }

  // 혼잡도 색상 결정 함수
  Color _getCongestionColor(int level) {
    if (level >= 90) return Colors.red;
    if (level >= 80) return Colors.orange;
    if (level >= 70) return Colors.yellow;
    if (level >= 60) return Colors.green;
    return Colors.blue;
  }

  // 혼잡도 아이콘
  Widget _buildStatusIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people,
            color: _getCongestionColor(congestionLevel),
            size: 18,
          ),
          Text(
            '$congestionLevel%',
            style: TextStyle(
              color: _getCongestionColor(congestionLevel),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 날씨 아이콘
  Widget _buildWeatherIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Icon(Icons.wb_sunny, color: Colors.yellow, size: 24),
    );
  }

  // 지도 아이콘
  Widget _buildMapIcon() {
    return GestureDetector(
      onTap: () {
        // TODO: 지도 앱 연결 기능 구현
        print('지도 버튼 클릭됨');
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(Icons.map, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildActionButton(String label) {
    return Expanded(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F5F6),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 3,
              offset: Offset(0, 1),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Color(0x4C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1D1B20),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
