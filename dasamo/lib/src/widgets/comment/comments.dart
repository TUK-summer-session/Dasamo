import 'package:dasamo/src/controllers/comments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Comments extends StatelessWidget {
  final CommentsController commentsController = Get.put(CommentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: commentsController.commentsList.map((comment) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20, 30, 0), // 패딩값 설정
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(comment['profileImage']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(comment['author']),
                  ],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        0, 0, 15, 20), // 원하는 패딩 값을 설정합니다.
                    child: Text(
                      comment['content'] ??
                          'No content', // content가 null일 경우를 대비해 기본값 설정
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
