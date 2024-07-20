import 'package:dasamo/src/screens/review/edit.dart';
import 'package:dasamo/src/screens/review/show.dart';
import 'package:flutter/material.dart';
import 'package:dasamo/src/widgets/buttons/review_tag_button.dart';
import 'package:get/get.dart';

const double _imageSize = 90;

class ReviewListItem extends StatelessWidget {
  final Map item;
  const ReviewListItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    List<String> tagList = List<String>.from(item['tagKind']); // 태그 리스트 생성

    return InkWell(
      onTap: () {
        Get.to(() => ReviewShow(item: item));
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
                        "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=1075&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
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
                              style: TextStyle(fontSize: 24),
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
