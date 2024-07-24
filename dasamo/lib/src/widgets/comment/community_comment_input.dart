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
  late CommunityCommentsController _communityCommentsController;
  final UserController userController =
      Get.find<UserController>(); // Get.find()로 수정

  @override
  void initState() {
    super.initState();
    _communityCommentsController = Get.put(
        CommunityCommentsController(widget.communityId),
        tag: widget.communityId.toString()); // 커뮤니티 ID를 초기화
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memberId = int.parse(userController.userId.value);
    final profileImageUrl = userController.profileImageUrl.value;

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
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                        profileImageUrl), // 유저의 프로필 이미지를 네트워크에서 가져옵니다.

                    fit: BoxFit.cover, // 이미지를 컨테이너 크기에 맞춤
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
                icon: Icon(Icons.arrow_circle_up_outlined), // 아이콘 설정
                onPressed: () async {
                  String comment = _textEditingController.text;
                  if (comment.isNotEmpty) {
                    await _communityCommentsController.postComment(
                        comment); // 댓글을 POST합니다.
                    _textEditingController.clear(); // 입력창 초기화
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
