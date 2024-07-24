import 'package:dasamo/src/controllers/review/reviews_comments_controller.dart';
import 'package:dasamo/src/controllers/user/user_controller.dart';
import 'package:dasamo/src/widgets/comment/separate_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewsCommentInput extends StatefulWidget {
  final Function(String) onSave;
  final int reviewId;

  const ReviewsCommentInput(
      {super.key, required this.reviewId, required this.onSave});

  @override
  _ReviewsCommentInputState createState() => _ReviewsCommentInputState();
}

class _ReviewsCommentInputState extends State<ReviewsCommentInput> {
  TextEditingController _textEditingController = TextEditingController();
  late ReviewsCommentsController _reviewsCommentsController;
  final UserController _userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    _reviewsCommentsController =
        Get.put(ReviewsCommentsController(widget.reviewId));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // 원하는 배경 색상 설정
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(_userController.profileImageUrl.value),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 24,
                  child: SeparateTextField(
                    controller: _textEditingController,
                    hintText: '댓글을 입력해주세요.',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_circle_up_outlined),
                onPressed: () async {
                  String comment = _textEditingController.text;
                  if (comment.isNotEmpty) {
                    await _reviewsCommentsController.postComment(comment);
                    _textEditingController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
