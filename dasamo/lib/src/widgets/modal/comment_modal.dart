import 'package:dasamo/src/controllers/comments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/widgets/comment/comment_input.dart';
import 'package:dasamo/src/widgets/comment/comments.dart';

class CommentModal extends StatelessWidget {
  const CommentModal({super.key});

  @override
  Widget build(BuildContext context) {
    final CommentsController commentsController =
        Get.find<CommentsController>();
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
                  Comments(), // Comments widget
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CommentInput(
              onSave: (comment) {
                // commentsController.addComment({
                //   'profileImage': 'assets/images/profile.jpg',
                //   'author': 'New User',
                //   'content': comment,
                // });
                print('저장된 댓글: $comment');
              },
            ),
          ),
        ],
      ),
    );
  }
}
