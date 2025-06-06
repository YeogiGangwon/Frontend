import 'package:flutter/material.dart';

class NewsCardList extends StatelessWidget {
  final List<String> newsList;
  const NewsCardList({Key? key, required this.newsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(newsList.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 32),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            newsList[index],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        );
      }),
    );
  }
} 