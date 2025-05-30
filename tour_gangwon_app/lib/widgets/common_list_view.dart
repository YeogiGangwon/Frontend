import 'package:flutter/material.dart';

class CommonListView extends StatelessWidget {
  final List<Map<String, String>> items;
  final String listTitle;
  final DateTime? date;

  const CommonListView({
    super.key,
    required this.items,
    required this.listTitle,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (date != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              '선택된 날짜: ${date!.toLocal()}'.split(' ')[0],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        else if (listTitle.contains('추천')) // Show "날짜 정보 없음" only for recommendation lists without a date
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              '날짜 정보 없음',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
        Text(
          listTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber), // Consider making this icon configurable
                  title: Text(item['title']!),
                  subtitle: Text(
                    item['description']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/recommendation_detail', // This navigation route might need to be dynamic if details screens are different
                      arguments: {
                        'title': item['title']!,
                        'description': item['description']!,
                        // Pass other necessary data if detail screens vary
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 