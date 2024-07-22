import 'package:flutter/material.dart';

class ShowReviewContent extends StatelessWidget {
  final Map<String, dynamic> item;

  const ShowReviewContent({
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 리뷰 제목과 내용
    final String title = item['title'] ?? 'No Title'; // 기본 제목
    final String description = item['detail'] ?? 'No Description'; // 기본 설명

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold, // 제목에 볼드체 적용
              color: Colors.black87, // 글자 색상
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54, // 글자 색상
            ),
          ),
          const SizedBox(height: 20), // 여백 추가
        ],
      ),
    );
  }
}
