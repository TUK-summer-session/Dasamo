import 'package:flutter/material.dart';

class ShowReviewContent extends StatelessWidget {
  final Map item;
  const ShowReviewContent({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['title'],
            style: TextStyle(
              fontSize: 18, // 글자 크기
              // 글자 색상
            ),
          ),
          SizedBox(height: 20),
          Text(
            item['description'],
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
