import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectionScreen extends StatefulWidget {
  const DateSelectionScreen({super.key});

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime? _selectedDate;

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
    final formattedDate = _selectedDate != null
        ? DateFormat('yyyy.MM.dd').format(_selectedDate!)
        : '날짜를 선택해주세요.';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  'assets/images/logo.png',
                  width: 160,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),

                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1D1B20),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // 날짜 선택 버튼 (가로폭 제한)
                SizedBox(
                  width: 200, // ✅ 가로 길이 제한으로 양옆 공백 확보
                  child: OutlinedButton(
                    onPressed: () => _selectDate(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(200, 48),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('날짜 선택하기'),
                  ),
                ),
                const SizedBox(height: 16),

                // 추천 보기 버튼 (같은 폭)
                SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    onPressed: _selectedDate == null
                        ? null
                        : () {
                            Navigator.pushNamed(
                              context,
                              '/search_result_list',
                              arguments: _selectedDate,
                            );
                          },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(200, 48),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('선택날짜 여행지 추천'),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
