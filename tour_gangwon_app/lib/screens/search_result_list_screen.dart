// lib/screens/search_result_list_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_gangwon_app/widgets/menu_bar.dart';
import '../models/place_model.dart';
import '../services/place_service.dart';

class SearchResultListScreen extends StatefulWidget {
  final DateTime date;

  const SearchResultListScreen({super.key, required this.date});

  @override
  State<SearchResultListScreen> createState() => _SearchResultListScreenState();
}

class _SearchResultListScreenState extends State<SearchResultListScreen> {
  List<Place> places = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      final loadedPlaces = await PlaceService.loadPlaces();
      setState(() {
        places = loadedPlaces;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading places: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy.MM.dd').format(widget.date);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F6),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 78,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                ),
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$formattedDate 추천 여행지',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D1B20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      final place = places[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/recommendation_detail',
                            arguments: place.id,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  place.image,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '혼잡도 점수: 78',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF49454F),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      place.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF1D1B20),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${place.location} · ${place.tags.join(', ')}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF49454F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const MessageWthLink(),
    );
  }
}
