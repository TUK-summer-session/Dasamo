import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/comments_controller.dart';

class Comments extends StatelessWidget {
  final int reviewId; // reviewId를 전달받기 위한 필드

  // 생성자에서 reviewId를 받음
  Comments({required this.reviewId});

  @override
  Widget build(BuildContext context) {
    // CommentsController를 생성할 때 reviewId를 전달
    final CommentsController commentsController =
        Get.put(CommentsController(reviewId));

    return Obx(() {
      if (commentsController.commentsList.isEmpty) {
        return Center(
          child: Text('No comments available.'),
        );
      }

      return ListView.builder(
        itemCount: commentsController.commentsList.length,
        itemBuilder: (context, index) {
          final comment = commentsController.commentsList[index];
          return ListTile(
            title: Text(comment['name']),
            subtitle: Text(comment['detail']),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(comment['profileImageUrl']),
            ),
          );
        },
      );
    });
  }
}
