import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/comments_controller.dart';

class Comments extends StatelessWidget {
  final int reviewId;

  const Comments({required this.reviewId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
