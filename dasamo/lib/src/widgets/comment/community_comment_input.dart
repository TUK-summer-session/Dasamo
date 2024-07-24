import 'package:dasamo/src/controllers/community_comments_controller.dart';
import 'package:dasamo/src/controllers/user/user_controller.dart';
import 'package:dasamo/src/widgets/comment/separate_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityCommentInput extends StatefulWidget {
  final Function(String) onSave;
  final int communityId;

  const CommunityCommentInput(
      {Key? key, required this.communityId, required this.onSave})
      : super(key: key);

  @override
  _CommunityCommentInputState createState() => _CommunityCommentInputState();
}

class _CommunityCommentInputState extends State<CommunityCommentInput> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.put(CommunityCommentsController(widget.communityId),
        tag: widget.communityId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final communityCommentsController = Get.find<CommunityCommentsController>(
        tag: widget.communityId.toString());
    final memberId = int.parse(Get.find<UserController>().userId.value);
    final profileImageUrl = Get.find<UserController>().profileImageUrl.value;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(profileImageUrl), fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 24,
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Enter your comment...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_circle_up_outlined),
                onPressed: () async {
                  String comment = _textEditingController.text;
                  if (comment.isNotEmpty) {
                    await communityCommentsController.postComment(
                        memberId, comment);
                    _textEditingController.clear();
                    widget.onSave(comment);
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
