import 'package:dasamo/src/widgets/list/star_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // intl 패키지 추가

class WriterInfo extends StatelessWidget {
  final String authorName;
  final String postDate;
  final String profileImage;
  final int starRating;

  // 기본 프로필 이미지의 경로를 정의합니다.
  static const String defaultProfileImage = 'assets/images/default_profile.png';

  const WriterInfo({
    required this.authorName,
    required this.postDate,
    required this.profileImage,
    required this.starRating,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 프로필 이미지가 유효한 URL인 경우와 기본 이미지의 조건을 구분합니다.
    final imageProvider = profileImage.isNotEmpty
        ? NetworkImage(profileImage) // URL 이미지 사용
        : AssetImage(defaultProfileImage) as ImageProvider; // 기본 이미지 사용

    // 날짜 형식을 변환합니다.
    final DateTime parsedDate = DateTime.parse(postDate);
    final String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // 프로필 이미지 및 작성자 정보
          Row(
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider, // 프로필 이미지
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10), // 간격 조절
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    authorName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold, // 강조된 폰트
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 별점 표시
          StarListWidget(number: starRating),
        ],
      ),
    );
  }
}
