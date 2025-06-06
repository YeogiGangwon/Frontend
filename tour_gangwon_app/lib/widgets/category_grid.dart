import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  final List<CategoryItem> items;
  final int crossAxisCount;
  const CategoryGrid({Key? key, required this.items, this.crossAxisCount = 4}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayItems = items.length > 10 ? items.sublist(0, 10) : items;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 0.9,
      ),
      itemCount: displayItems.length,
      itemBuilder: (context, index) {
        final item = displayItems[index];
        return GestureDetector(
          onTap: item.onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Text('버튼1'), // 실제 아이콘/이미지로 교체 가능
              ),
              const SizedBox(height: 6),
              Text(item.label, style: const TextStyle(fontSize: 13)),
            ],
          ),
        );
      },
    );
  }
}

class CategoryItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  CategoryItem({required this.icon, required this.label, required this.onTap});
} 