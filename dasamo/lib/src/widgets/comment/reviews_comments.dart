import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/reviews_comments_controller.dart';

class ReviewsComments extends StatelessWidget {
  final int reviewId;

  const ReviewsComments({required this.reviewId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReviewsCommentsController commentsController =
        Get.put(ReviewsCommentsController(reviewId));

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
