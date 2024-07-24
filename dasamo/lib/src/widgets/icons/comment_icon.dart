import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/review/reviews_comments_controller.dart';
import 'package:dasamo/src/widgets/comment/reviews_comment_input.dart';
import 'package:dasamo/src/widgets/comment/reviews_comments.dart';

class CommentIcon extends StatefulWidget {
  final int reviewId;
  const CommentIcon({super.key, required this.reviewId});

  @override
  _CommentIconState createState() => _CommentIconState();
}

class _CommentIconState extends State<CommentIcon> {
  bool _hovered = false;
  late ReviewsCommentsController _reviewsCommentsController;

  @override
  void initState() {
    super.initState();
    _reviewsCommentsController = Get.put(ReviewsCommentsController(widget.reviewId));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hovered) {
        setState(() {
          _hovered = hovered;
        });
      },
      onTap: () {
        // Ensure that the controller is updated before showing the bottom sheet
        _reviewsCommentsController.updateReviewId(widget.reviewId);
        
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
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
                  Expanded(
                    child: ReviewsComments(
                      reviewId: widget.reviewId,
                    ),
                  ),
                  ReviewsCommentInput(
                    onSave: (comment) {
                      _reviewsCommentsController.postComment(comment);
                    },
                    reviewId: widget.reviewId,
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Icon(
        _hovered ? Icons.chat_bubble : Icons.chat_bubble_outline,
        color: _hovered ? Color.fromRGBO(175, 99, 120, 1.0) : null,
        size: 22,
      ),
    );
  }
}
