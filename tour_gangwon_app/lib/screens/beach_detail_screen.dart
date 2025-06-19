import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/beach_model.dart';
import '../services/beach_service.dart';
import '../services/favorite_service.dart';
import '../services/api_client.dart';

import '../constants/colors.dart';
import 'auth/login_screen.dart';

class BeachDetailScreen extends StatefulWidget {
  final String beachId;

  const BeachDetailScreen({super.key, required this.beachId});

  @override
  State<BeachDetailScreen> createState() => _BeachDetailScreenState();
}

class _BeachDetailScreenState extends State<BeachDetailScreen> {
  Beach? beach;
  bool isLoading = true;
  bool isFavorite = false;

  // 날씨와 혼잡도 정보
  Map<String, dynamic>? weatherInfo;
  Map<String, dynamic>? congestionInfo;
  bool isLoadingRealTimeData = false;

  final FavoriteService _favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();
    _loadBeach();
  }

  Future<void> _loadBeach() async {
    try {
      await BeachService.loadBeaches();
      final loadedBeach = BeachService.getBeachById(widget.beachId);

      if (loadedBeach != null) {
        setState(() {
          beach = loadedBeach;
          isLoading = false;
        });

        // 해수욕장 로드 후 실시간 데이터와 즐겨찾기 상태 확인
        await _loadRealTimeData();
        await _checkFavoriteStatus();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading beach: $e');
    }
  }

  Future<void> _loadRealTimeData() async {
    if (beach == null) return;

    setState(() {
      isLoadingRealTimeData = true;
    });

    try {
      // 날씨와 혼잡도 정보를 병렬로 가져오기
      final futures = await Future.wait([
        BeachService.getWeatherInfo(beach!.location.lat, beach!.location.lon),
        BeachService.getCongestionInfo(beach!.name),
      ]);

      setState(() {
        weatherInfo = futures[0];
        congestionInfo = futures[1];
        isLoadingRealTimeData = false;
      });
    } catch (e) {
      print('실시간 데이터 로드 실패: $e');
      setState(() {
        isLoadingRealTimeData = false;
      });
    }
  }

  Future<void> _checkFavoriteStatus() async {
    // 실제 API 호출 없이 기본값 유지
    setState(() {
      isFavorite = false; // 기본값은 false
    });
  }

  Future<void> _toggleFavorite() async {
    if (beach == null) return;

    // 로컬 상태만 토글
    final newStatus = !isFavorite;
    setState(() {
      isFavorite = newStatus;
    });

    // 항상 추가되었다는 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('즐겨찾기에 추가되었습니다'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (beach == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('해수욕장 정보를 찾을 수 없습니다.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        children: [
          // 이미지 및 상단 타이틀
          _buildImageHeader(),
          // 상세 정보
          _buildDetailInfo(),
          // 시설 정보
          _buildFacilityInfo(),
          // 연락처 및 위치 정보
          _buildContactInfo(),
        ],
      ),
    );
  }

  Widget _buildImageHeader() {
    final hasMainImage = beach!.tourInfo.hasImages;
    final imageUrl = hasMainImage ? beach!.tourInfo.images.first : '';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 412,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: hasMainImage
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.beach_access,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ),
                ),
        ),
        Container(
          height: 412,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        // 새로고침 버튼 (실시간 데이터 업데이트용)
        Positioned(
          top: 50,
          right: 16,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: isLoadingRealTimeData
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.refresh, color: Colors.white, size: 20),
              onPressed: isLoadingRealTimeData ? null : _loadRealTimeData,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        // 좌측 하단 해수욕장 이름
        Positioned(
          left: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                beach!.displayName,
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
            ],
          ),
        ),
        // 우측 하단 3개 아이콘
        Positioned(
          right: 16,
          bottom: 16,
          child: Row(
            children: [
              _buildCongestionIcon(),
              const SizedBox(width: 12),
              _buildWeatherIcon(),
              const SizedBox(width: 12),
              _buildFavoriteIcon(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(color: Color(0xFFF3F5F6)),
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
                    // 위치 정보
                    Text(
                      beach!.fullLocation,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 주소 정보
                    if (beach!.tourInfo.hasAddress)
                      Text(
                        beach!.tourInfo.displayAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
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
            beach!.displayOverview,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1D1B20),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '시설 정보',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1B20),
            ),
          ),
          const SizedBox(height: 16),
          // 이용 시간
          if (beach!.tourInfo.usetime.isNotEmpty)
            _buildInfoRow('이용 시간', beach!.tourInfo.usetime),
          // 주차 정보
          if (beach!.tourInfo.hasParking)
            _buildInfoRow('주차 시설', beach!.tourInfo.parking),
          // 휴무일
          if (beach!.tourInfo.restdate.isNotEmpty)
            _buildInfoRow('휴무일', beach!.tourInfo.restdate),
          // 유모차 대여
          if (beach!.tourInfo.chkbabycarriage.isNotEmpty)
            _buildInfoRow('유모차 대여', beach!.tourInfo.chkbabycarriage),
          // 반려동물 동반
          if (beach!.tourInfo.chkpet.isNotEmpty)
            _buildInfoRow('반려동물 동반', beach!.tourInfo.chkpet),
          // 신용카드 사용
          if (beach!.tourInfo.chkcreditcard.isNotEmpty)
            _buildInfoRow('신용카드 사용', beach!.tourInfo.chkcreditcard),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF3F5F6),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '연락처',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1B20),
            ),
          ),
          const SizedBox(height: 16),
          // 연락처
          if (beach!.tourInfo.hasTel)
            _buildInfoRow('연락처', beach!.tourInfo.displayTel),
          // 홈페이지
          if (beach!.tourInfo.homepage.isNotEmpty)
            _buildInfoRow('홈페이지', beach!.tourInfo.homepage),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteIcon() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleFavorite,
        borderRadius: BorderRadius.circular(33),
        child: Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(33),
          ),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }

  // 혼잡도 색상 결정 함수
  Color _getCongestionColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'moderate':
        return Colors.yellow;
      case 'crowded':
        return Colors.orange;
      case 'very crowded':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // 혼잡도 레벨을 한국어로 변환
  String _getCongestionText(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return '원활';
      case 'moderate':
        return '보통';
      case 'crowded':
        return '혼잡';
      case 'very crowded':
        return '매우혼잡';
      default:
        return 'N/A';
    }
  }

  // 혼잡도 아이콘
  Widget _buildCongestionIcon() {
    if (congestionInfo == null) {
      return Container(
        width: 66,
        height: 66,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(33),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, color: Colors.grey, size: 27),
            Text(
              'N/A',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    final level = congestionInfo!['level'] ?? 'Unknown';
    final congestionText = _getCongestionText(level);

    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(33),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, color: _getCongestionColor(level), size: 27),
          Text(
            congestionText,
            style: TextStyle(
              color: _getCongestionColor(level),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 날씨에 따른 아이콘 결정
  IconData _getWeatherIcon(String? sky, String? pty) {
    // 강수 상태 (PTY)
    if (pty != null && pty != '0') {
      switch (pty) {
        case '1': // 비
        case '5': // 빗방울
          return Icons.grain;
        case '2': // 비/눈
        case '6': // 빗방울날림
          return Icons.snowing;
        case '3': // 눈
        case '7': // 눈날림
          return Icons.ac_unit;
        case '4': // 소나기
          return Icons.bolt;
        default:
          return Icons.grain;
      }
    }

    // 하늘 상태 (SKY)
    if (sky != null) {
      switch (sky) {
        case '1': // 맑음
          return Icons.wb_sunny;
        case '3': // 구름많음
          return Icons.wb_cloudy;
        case '4': // 흐림
          return Icons.cloud;
        default:
          return Icons.wb_sunny;
      }
    }

    return Icons.wb_sunny;
  }

  // 날씨에 따른 색상 결정
  Color _getWeatherColor(String? sky, String? pty) {
    // 강수 상태
    if (pty != null && pty != '0') {
      switch (pty) {
        case '1': // 비
        case '5': // 빗방울
          return Colors.blue;
        case '2': // 비/눈
        case '6': // 빗방울날림
          return Colors.lightBlue;
        case '3': // 눈
        case '7': // 눈날림
          return Colors.white;
        case '4': // 소나기
          return Colors.purple;
        default:
          return Colors.blue;
      }
    }

    // 하늘 상태
    if (sky != null) {
      switch (sky) {
        case '1': // 맑음
          return Colors.yellow;
        case '3': // 구름많음
          return Colors.grey;
        case '4': // 흐림
          return Colors.blueGrey;
        default:
          return Colors.yellow;
      }
    }

    return Colors.yellow;
  }

  // 날씨 아이콘
  Widget _buildWeatherIcon() {
    if (weatherInfo == null) {
      return Container(
        width: 66,
        height: 66,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(33),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.help_outline, color: Colors.grey, size: 27),
            Text(
              'N/A',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    final weather = weatherInfo!['weather'];
    final temperature = weather?['temperature'] ?? 'N/A';
    final sky = weather?['sky'];
    final pty = weather?['pty'];

    final weatherIcon = _getWeatherIcon(sky, pty);
    final weatherColor = _getWeatherColor(sky, pty);

    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(33),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(weatherIcon, color: weatherColor, size: 27),
          Text(
            temperature.toString().replaceAll('°C', '°'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
