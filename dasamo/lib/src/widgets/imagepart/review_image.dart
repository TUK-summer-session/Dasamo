import 'package:flutter/material.dart';

class ReviewImage extends StatelessWidget {
  final String imageUrl;

  const ReviewImage({
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // URL이 "http"로 시작하는 경우 네트워크 이미지로 처리
    final isNetworkImage = imageUrl.startsWith('http');

    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: isNetworkImage
              ? NetworkImage(imageUrl) as ImageProvider
              : AssetImage(imageUrl) as ImageProvider,
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
