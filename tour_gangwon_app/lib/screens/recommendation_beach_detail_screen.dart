import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecommendationBeachDetailScreen extends StatefulWidget {
  final Map<String, dynamic> beachData;

  const RecommendationBeachDetailScreen({super.key, required this.beachData});

  @override
  State<RecommendationBeachDetailScreen> createState() =>
      _RecommendationBeachDetailScreenState();
}

class _RecommendationBeachDetailScreenState
    extends State<RecommendationBeachDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final beach = widget.beachData;
    final mainImage = beach['tourInfo']['mainImage'] ?? '';
    final images = List<String>.from(beach['tourInfo']['images'] ?? []);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        children: [
          // 이미지 및 상단 타이틀
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: mainImage.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: mainImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(28),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue.shade400,
                                  Colors.blue.shade600,
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.beach_access,
                                    size: 64,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '해수욕장 이미지',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade600,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.beach_access,
                                size: 64,
                                color: Colors.white,
                              ),
                              SizedBox(height: 16),
                              Text(
                                '해수욕장 이미지',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),

              // 그라데이션 오버레이
              Container(
                height: 400,
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
                      Colors.black.withOpacity(0.6),
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

              // 해수욕장 이름과 점수
              Positioned(
                left: 16,
                bottom: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            beach['name'],
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
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '추천 점수: ${beach['totalScore']}점',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _buildWeatherIcon(beach['weather']),
                        const SizedBox(width: 8),
                        _buildCongestionIcon(beach['congestion']),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 상세 정보 섹션
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F5F6),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 기본 정보
                _buildInfoSection('기본 정보', [
                  _buildInfoRow(
                    '주소',
                    beach['tourInfo']['address'] ?? '주소 정보 없음',
                  ),
                  _buildInfoRow('설명', beach['description'] ?? '설명 없음'),
                ]),

                const SizedBox(height: 24),

                // 날씨 정보
                _buildInfoSection('현재 날씨', [
                  _buildInfoRow('날씨 상태', beach['weather']['sky']),
                  _buildInfoRow('기온', beach['weather']['temp']),
                  _buildInfoRow('날씨 점수', '${beach['weather']['score']}점'),
                ]),

                const SizedBox(height: 24),

                // 혼잡도 정보
                _buildInfoSection('혼잡도', [
                  _buildInfoRow(
                    '혼잡도 상태',
                    _getCongestionLevelText(beach['congestion']['level']),
                  ),
                  _buildInfoRow('혼잡도 점수', '${beach['congestion']['score']}점'),
                  if (beach['congestion']['personCount'] != null)
                    _buildInfoRow(
                      '인원 수',
                      '${beach['congestion']['personCount']}명',
                    ),
                ]),

                const SizedBox(height: 24),

                // 상세 설명
                if (beach['tourInfo']['overview'] != null &&
                    beach['tourInfo']['overview'].isNotEmpty)
                  _buildDetailSection('상세 설명', beach['tourInfo']['overview']),

                const SizedBox(height: 24),

                // 즐겨찾기 버튼
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? '즐겨찾기에 추가되었습니다.'
                                    : '즐겨찾기에서 제거되었습니다.',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey.shade600,
                        ),
                        label: Text(
                          isFavorite ? '즐겨찾기 제거' : '즐겨찾기 추가',
                          style: TextStyle(
                            color: isFavorite
                                ? Colors.red
                                : Colors.grey.shade700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isFavorite
                                  ? Colors.red
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherIcon(Map<String, dynamic> weather) {
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
            weather['sky'] == '맑음' ? Icons.wb_sunny : Icons.cloud,
            color: weather['sky'] == '맑음'
                ? Colors.yellow
                : Colors.grey.shade300,
            size: 16,
          ),
          Text(
            weather['temp'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCongestionIcon(Map<String, dynamic> congestion) {
    Color congestionColor = _getCongestionColor(congestion['level']);

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
          Icon(Icons.people, color: congestionColor, size: 16),
          Text(
            '${congestion['score']}',
            style: TextStyle(
              color: congestionColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getCongestionLevelText(String level) {
    switch (level) {
      case 'low':
        return '여유';
      case 'medium':
        return '보통';
      case 'high':
        return '혼잡';
      default:
        return '정보없음';
    }
  }

  Color _getCongestionColor(String level) {
    switch (level) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
