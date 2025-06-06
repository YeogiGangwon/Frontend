import 'package:flutter/material.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String location;
  final VoidCallback? onLocationTap;
  final TextEditingController searchController;
  final VoidCallback? onSearch;
  final VoidCallback? onBookmark;
  final VoidCallback? onNotification;
  final bool hasNotification;

  const CustomHomeAppBar({
    Key? key,
    required this.location,
    this.onLocationTap,
    required this.searchController,
    this.onSearch,
    this.onBookmark,
    this.onNotification,
    this.hasNotification = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            GestureDetector(
              onTap: onLocationTap,
              child: Row(
                children: [
                  const Icon(Icons.place, color: Colors.grey, size: 22),
                  const SizedBox(width: 2),
                  Text(location, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    const Icon(Icons.search, color: Colors.grey, size: 22),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: '검색 급상승으로 검색해보세요!',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onSubmitted: (_) => onSearch?.call(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_outlined, color: Colors.black),
                  onPressed: onNotification,
                ),
                if (hasNotification)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 