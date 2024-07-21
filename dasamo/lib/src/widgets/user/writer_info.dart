import 'package:dasamo/src/widgets/list/star_list_widget.dart';
import 'package:flutter/material.dart';

class WriterInfo extends StatelessWidget {
  final String authorName;
  final String postDate;
  final String profileImage;
  final int starRating;

  const WriterInfo({
    required this.authorName,
    required this.postDate,
    required this.profileImage,
    required this.starRating,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // 프로필 이미지 및 작성자 정보
          Row(
            children: <Widget>[
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(profileImage), // 프로필 이미지
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20), // 간격 조절
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold, // 강조된 폰트
                    ),
                  ),
                  const SizedBox(height: 2), // 간격 조절
                  Text(
                    postDate,
                    style: const TextStyle(
                      fontSize: 12,
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
