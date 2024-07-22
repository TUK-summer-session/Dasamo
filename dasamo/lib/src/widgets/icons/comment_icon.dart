import 'package:dasamo/src/widgets/comment/reviews_comment_input.dart';
import 'package:dasamo/src/widgets/comment/comments.dart';
import 'package:flutter/material.dart';

class CommentIcon extends StatefulWidget {
  const CommentIcon({Key? key}) : super(key: key);

  @override
  _CommentIconState createState() => _CommentIconState();
}

class _CommentIconState extends State<CommentIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hovered) {
        setState(() {
          _hovered = hovered;
        });
      },
      onTap: () {
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
                    child: Comments(
                      reviewId: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CommentInput(
                      onSave: (comment) {
                        print('저장된 댓글: $comment');
                      },
                    ),
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
