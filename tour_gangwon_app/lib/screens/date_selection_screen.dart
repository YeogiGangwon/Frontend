import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectionScreen extends StatefulWidget {
  const DateSelectionScreen({super.key});

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime? _selectedDate;
  final List<String> _categories = [
    '해수욕장',
    '등산',
    '산책',
    '시장',
    '문화재',
    '액티비티',
    '카페',
    '전시',
    '체험',
    '계곡',
    '스키장',
    '스포츠',
  ];
  final Set<String> _selectedCategories = {};

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final DateTime showDate = _selectedDate ?? today;
    final formattedDate = DateFormat('yyyy.MM.dd').format(showDate);
    final isDark = true;

    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  // Headline
                  Center(
                    child: Text(
                      '혼잡도, 거리, 날씨를 기반으로\n최적의 여행지를 확인할 수 있어요',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Logo image (임시)
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 날짜 카드 (세로 배치)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 28,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF23242A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF4A90E2),
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: 180,
                          child: OutlinedButton(
                            onPressed: () => _selectDate(context),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: const Color(0xFF4A90E2),
                              side: const BorderSide(
                                color: Color(0xFF4A90E2),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                            ),
                            child: const Text(
                              '다른날 여행하기',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A90E2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 카테고리 멀티 선택 버튼들
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: _categories.map((cat) {
                      final bool selected = _selectedCategories.contains(cat);
                      return ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cat,
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (selected) ...[
                              const SizedBox(width: 4),
                              Icon(Icons.check, color: Colors.white, size: 18),
                            ],
                          ],
                        ),
                        selected: selected,
                        selectedColor: const Color(0xFF4A90E2),
                        backgroundColor: const Color(0xFF23242A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onSelected: (val) {
                          setState(() {
                            if (selected) {
                              _selectedCategories.remove(cat);
                            } else {
                              _selectedCategories.add(cat);
                            }
                          });
                        },
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 100), // for bottom button space
                ],
              ),
            ),
            // 상단 좌측 뒤로가기 버튼
            Positioned(
              top: 10,
              left: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            // 하단 고정 추천받기 버튼
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/search_result_list',
                        arguments: showDate,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('추천받기'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
