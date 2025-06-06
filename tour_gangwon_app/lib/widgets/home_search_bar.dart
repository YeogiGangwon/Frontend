import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSearch;

  const HomeSearchBar({Key? key, required this.controller, this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: '여행지를 검색해보세요!',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            onSubmitted: (_) => onSearch?.call(),
          ),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: onSearch,
        ),
      ],
    );
  }
} 