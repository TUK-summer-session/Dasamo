import 'package:dasamo/src/controllers/community_comments_controller.dart';
import 'package:dasamo/src/widgets/comment/community_comment_input.dart';
import 'package:dasamo/src/widgets/comment/community_comments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityCommentIcon extends StatefulWidget {
  final int communityId;

  const CommunityCommentIcon({super.key, required this.communityId});

  @override
  _CommunityCommentIconState createState() => _CommunityCommentIconState();
}

class _CommunityCommentIconState extends State<CommunityCommentIcon> {
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => CommunityCommentsController(widget.communityId),
        tag: widget.communityId.toString());
    CommunityCommentsController _communityCommentsController =
        Get.find(tag: widget.communityId.toString());
    _communityCommentsController.fetchComments();
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
                    child: CommunityComments(
                      communityId: widget.communityId,
                    ),
                  ),
                  CommunityCommentInput(
                    onSave: (comment) {
                      print('저장된 댓글: $comment');
                    },
                    communityId: widget.communityId,
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
