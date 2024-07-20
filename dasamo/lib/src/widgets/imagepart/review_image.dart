import 'package:flutter/material.dart';

class ReviewImage extends StatelessWidget {
  final String imageUrl;

  const ReviewImage({
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl), // 로컬 이미지
          fit: BoxFit.cover, // 이미지를 컨테이너 크기에 맞춤
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // 그림자 색상과 투명도
            spreadRadius: 0.5, // 그림자 크기
            blurRadius: 3, // 흐림 정도
            offset: Offset(0, 3), // 그림자 위치 (x, y)
          ),
        ],
      ),
    );
  }
}
