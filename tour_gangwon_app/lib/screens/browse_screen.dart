import 'package:flutter/material.dart';
import '../models/beach_model.dart';
import '../services/beach_service.dart';
import '../constants/colors.dart';
import 'beach_detail_screen.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  List<Beach> beaches = [];
  List<Beach> filteredBeaches = [];
  bool isLoading = true;
  String selectedCategory = '해수욕장';

  final List<Map<String, dynamic>> categories = [
    {'name': '해수욕장', 'icon': Icons.beach_access, 'enabled': true},
    {'name': '산', 'icon': Icons.landscape, 'enabled': false},
    {'name': '시장', 'icon': Icons.store, 'enabled': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadBeaches();
  }

  Future<void> _loadBeaches() async {
    try {
      await BeachService.loadBeaches();
      final loadedBeaches = BeachService.getAllBeaches();

      setState(() {
        beaches = loadedBeaches;
        filteredBeaches = loadedBeaches;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading beaches: $e');
    }
  }

  void _onCategoryTap(String categoryName, bool enabled) {
    if (!enabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('준비 중입니다. 현재는 해수욕장만 이용 가능합니다'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() {
      selectedCategory = categoryName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '찾아보기',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 카테고리 선택 영역
                _buildCategorySelection(),
                // 목록 영역
                Expanded(
                  child: selectedCategory == '해수욕장'
                      ? _buildBeachList()
                      : _buildComingSoon(),
                ),
              ],
            ),
    );
  }

  Widget _buildCategorySelection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '카테고리를 선택하세요',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: categories.map((category) {
              final isSelected = selectedCategory == category['name'];
              final isEnabled = category['enabled'] as bool;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _onCategoryTap(category['name'], isEnabled),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isEnabled ? Colors.white : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isEnabled
                                  ? AppColors.border
                                  : Colors.grey.shade300),
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category['icon'],
                          size: 36,
                          color: isSelected
                              ? Colors.white
                              : (isEnabled
                                    ? AppColors.primary
                                    : Colors.grey.shade400),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : (isEnabled
                                      ? AppColors.textPrimary
                                      : Colors.grey.shade400),
                          ),
                        ),
                        if (!isEnabled) ...[
                          const SizedBox(height: 4),
                          Text(
                            '준비중',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBeachList() {
    return filteredBeaches.isEmpty
        ? const Center(
            child: Text(
              '해수욕장 정보가 없습니다.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredBeaches.length,
            itemBuilder: (context, index) {
              return _buildBeachCard(filteredBeaches[index]);
            },
          );
  }

  Widget _buildComingSoon() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            '준비 중입니다',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '해당 카테고리는 현재 개발 중입니다.\n해수욕장 카테고리를 이용해 주세요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
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
