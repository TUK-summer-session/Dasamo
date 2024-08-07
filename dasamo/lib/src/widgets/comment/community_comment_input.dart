import 'package:dasamo/src/controllers/community_comments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityCommentInput extends StatefulWidget {
  final Function(String) onSave;

  const CommunityCommentInput({Key? key, required this.onSave})
      : super(key: key);

  @override
  _CommunityCommentInputState createState() => _CommunityCommentInputState();
}

class _CommunityCommentInputState extends State<CommunityCommentInput> {
  TextEditingController _textEditingController = TextEditingController();
  late CommunityCommentsController _communityCommentsController;

  @override
  void initState() {
    super.initState();
    _communityCommentsController =
        Get.put(CommunityCommentsController(1)); // 커뮤니티 ID를 1로 설정
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
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/profile.jpg'), // 로컬 이미지
                  fit: BoxFit.cover, // 이미지를 컨테이너 크기에 맞춤
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: '댓글을 입력하세요...', // 입력창 안내 메시지
                  border: OutlineInputBorder(), // 테두리 스타일
                ),
                maxLines: 3, // 최대 줄 수
                minLines: 1, // 최소 줄 수
                onChanged: (text) {
                  // 입력된 텍스트를 상태로 관리하거나 필요한 경우 처리
                },
              ),
            ),
            SizedBox(width: 8), // 아이콘과 TextField 사이 간격 조정
            IconButton(
              icon: Icon(Icons.arrow_upward), // 아이콘 설정
              onPressed: () async {
                String comment = _textEditingController.text;
                if (comment.isNotEmpty) {
                  await _communityCommentsController
                      .postComment(comment); // 댓글을 POST합니다.
                  _textEditingController.clear(); // 입력창 초기화
                }
              },
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
