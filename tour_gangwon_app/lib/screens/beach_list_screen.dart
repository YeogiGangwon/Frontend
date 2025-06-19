import 'package:flutter/material.dart';
import '../models/beach_model.dart';
import '../services/beach_service.dart';
import '../constants/colors.dart';
import 'beach_detail_screen.dart';

class BeachListScreen extends StatefulWidget {
  const BeachListScreen({super.key});

  @override
  State<BeachListScreen> createState() => _BeachListScreenState();
}

class _BeachListScreenState extends State<BeachListScreen> {
  List<Beach> beaches = [];
  List<Beach> filteredBeaches = [];
  bool isLoading = true;
  String searchQuery = '';
  String selectedCity = '전체';
  List<String> cities = ['전체'];

  @override
  void initState() {
    super.initState();
    _loadBeaches();
  }

  Future<void> _loadBeaches() async {
    try {
      await BeachService.loadBeaches();
      final loadedBeaches = BeachService.getAllBeaches();
      final loadedCities = ['전체'] + BeachService.getCities();

      setState(() {
        beaches = loadedBeaches;
        filteredBeaches = loadedBeaches;
        cities = loadedCities;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading beaches: $e');
    }
  }

  void _filterBeaches() {
    setState(() {
      filteredBeaches = beaches.where((beach) {
        final matchesSearch =
            searchQuery.isEmpty ||
            beach.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            beach.city.toLowerCase().contains(searchQuery.toLowerCase()) ||
            beach.description.toLowerCase().contains(searchQuery.toLowerCase());

        final matchesCity = selectedCity == '전체' || beach.city == selectedCity;

        return matchesSearch && matchesCity;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '강원도 해수욕장',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 검색 및 필터 영역
                _buildSearchAndFilter(),
                // 해수욕장 목록
                Expanded(
                  child: filteredBeaches.isEmpty
                      ? const Center(
                          child: Text(
                            '검색 결과가 없습니다.',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredBeaches.length,
                          itemBuilder: (context, index) {
                            return _buildBeachCard(filteredBeaches[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 검색 바
          TextField(
            onChanged: (value) {
              searchQuery = value;
              _filterBeaches();
            },
            decoration: InputDecoration(
              hintText: '해수욕장 이름 또는 지역으로 검색',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              filled: true,
              fillColor: AppColors.surfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          // 도시 필터
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: cities.map((city) {
                final isSelected = selectedCity == city;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(city),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCity = city;
                      });
                      _filterBeaches();
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.primary.withOpacity(0.1),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeachCard(Beach beach) {
    final hasImage = beach.tourInfo.hasImages;
    final imageUrl = hasImage ? beach.tourInfo.images.first : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BeachDetailScreen(beachId: beach.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 영역
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                color: Colors.grey[300],
              ),
              child: hasImage
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.beach_access,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
            // 정보 영역
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 해수욕장 이름과 도시
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          beach.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          beach.city,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 설명
                  Text(
                    beach.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // 시설 정보 아이콘들
                  Row(
                    children: [
                      if (beach.tourInfo.hasParking)
                        _buildFeatureIcon(Icons.local_parking, '주차'),
                      if (beach.tourInfo.hasTel)
                        _buildFeatureIcon(Icons.phone, '연락처'),
                      if (beach.tourInfo.usetime.isNotEmpty)
                        _buildFeatureIcon(Icons.access_time, '운영시간'),
                      if (beach.tourInfo.hasImages)
                        _buildFeatureIcon(Icons.photo_camera, '사진'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
