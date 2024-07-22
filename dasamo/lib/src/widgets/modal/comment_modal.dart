import 'package:dasamo/src/controllers/comments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/widgets/comment/comment_input.dart';
import 'package:dasamo/src/widgets/comment/comments.dart';

class CommentModal extends StatelessWidget {
  final int reviewId; // reviewId를 전달받기 위한 필드

  // 생성자에서 reviewId를 받음
  CommentModal(
      {super.key,
      required this.reviewId,
      required CommentsController commentsController});

  @override
  Widget build(BuildContext context) {
    // reviewId를 사용하여 CommentsController를 초기화
    final CommentsController commentsController =
        Get.put(CommentsController(reviewId));
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      height: screenHeight * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  // Comments 위젯에 reviewId 전달
                  Comments(reviewId: reviewId),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CommentInput(
              onSave: (comment) {
                // 댓글 추가 로직 구현
                print('저장된 댓글: $comment');
              },
            ),
          ),
        ],
      ),
    );
  }
}
