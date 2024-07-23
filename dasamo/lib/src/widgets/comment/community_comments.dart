import 'package:dasamo/src/controllers/community_comments_controller.dart';
import 'package:dasamo/src/controllers/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityComments extends StatelessWidget {
  final int communityId;

  const CommunityComments({required this.communityId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CommunityCommentsController communityCommentsController =
        Get.put(CommunityCommentsController(communityId));
    //  final UserController userController = Get.put(UserController());

    //  final int memberId =
    // int.parse(userController.userId.value);

    return Obx(() {
      if (communityCommentsController.communityCommentsList.isEmpty) {
        return Center(
          child: Text('No comments available.'),
        );
      }

      return ListView.builder(
        itemCount: communityCommentsController.communityCommentsList.length,
        itemBuilder: (context, index) {
          final comment =
              communityCommentsController.communityCommentsList[index];

          final commentId = comment['commentId'] as int?;
          final memberId = comment['memberId'] as int?;

          return ListTile(
            title: Text(comment['name']),
            subtitle: Text(comment['detail']),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(comment['profileImageUrl']),
            ),
            // member id가 1이면
            trailing: comment['memberId'] == memberId
                ? IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () async {
                      if (commentId == null || memberId == null) {
                        // 댓글 ID 또는 멤버 ID가 null인 경우
                        print(
                            'Invalid comment ID or member ID: commentId=$commentId, memberId=$memberId');
                        return;
                      }
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
                        await communityCommentsController.deleteComment(
                          comment['commentId'],
                          comment['memberId'],
                        );
                      }
                    },
                  )
                : null,
          );
        },
      );
    });
  }
}
