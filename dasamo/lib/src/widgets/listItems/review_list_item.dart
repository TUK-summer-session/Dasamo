import 'package:dasamo/src/screens/review/show.dart';
import 'package:flutter/material.dart';
import 'package:dasamo/src/widgets/buttons/tags/review_tag_button.dart';
import 'package:get/get.dart';

const double _imageSize = 80;

class ReviewListItem extends StatelessWidget {
  final Map item;
  const ReviewListItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    List<String> tagList = List<String>.from(item['tagKind']); // 태그 리스트 생성

    return InkWell(
      onTap: () {
        Get.toNamed('/review/${item['id']}'); // reviewId로 라우팅
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        item['imageFile'] ?? 'https://via.placeholder.com/150',
                        width: _imageSize,
                        height: _imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 리뷰할 물건의 제목
                            Text(
                              item['title'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            // 리뷰할 물건의 설명
                            Text(
                              item['description'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: tagList.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: ReviewTagButton(
                              title: tag.trim(), // 각 태그를 ReviewTagButton으로 변환
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 18,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              item['like'].toString(),
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.chat_bubble_outline_outlined,
                              size: 18,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              item['comment'].toString(),
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
