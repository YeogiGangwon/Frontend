import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../services/place_service.dart';

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
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      place!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '혼잡도 점수: 78',
                      style: TextStyle(
                        color: Color(0xFFF5EFF7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildActionButton('일정 재검색'),
                        const SizedBox(width: 8),
                        _buildActionButton('길찾기'),
                        const SizedBox(width: 8),
                        _buildActionButton('날씨(맑음)'),
                      ],
                    ),
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
                Text(
                  place!.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1D1B20),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  place!.location,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF49454F),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: place!.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8DEF8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF65558F),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  '상세 설명',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF49454F),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  place!.explain,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1D1B20),
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
