import 'package:dasamo/src/controllers/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/review/reviews_comments_controller.dart';

class ReviewsComments extends StatelessWidget {
  final int reviewId;

  const ReviewsComments({required this.reviewId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReviewsCommentsController commentsController =
        Get.put(ReviewsCommentsController(reviewId));

    final UserController _userController = Get.put(UserController());

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
            title: Text(
              comment['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              comment['detail'],
              style: TextStyle(fontSize: 16),
            ),
            leading: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(comment['profileImageUrl']),
            ),
            trailing:
                comment['memberId'] == int.parse(_userController.userId.value)
                    ? Padding(
                        padding:
                            const EdgeInsets.only(left: 30.0), // 왼쪽에 16픽셀 간격 추가
                        child: IconButton(
                          icon: Icon(
                            Icons.more_horiz_outlined,
                            color: Colors.black,
                            size: 14,
                          ),
                          onPressed: () async {
                            // 삭제 버튼 클릭 시 수행할 작업
                            bool? confirmed = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('삭제 확인'),
                                  content: Text('이 댓글을 삭제하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      child: Text('취소'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('삭제'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmed ?? false) {
                              // 댓글 삭제 작업 수행
                              await commentsController.deleteComment(
                                comment['questionId'],
                                comment['memberId'],
                              );
                            }
                          },
                        ),
                      )
                    : null,
          );
        },
      );
    });
  }
}
