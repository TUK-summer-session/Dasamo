import 'package:dasamo/src/controllers/community_comments_controller.dart';
import 'package:dasamo/src/controllers/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityComments extends StatelessWidget {
  final int communityId;

  const CommunityComments({required this.communityId, super.key});

  @override
  Widget build(BuildContext context) {
    final CommunityCommentsController communityCommentsController =
        Get.find<CommunityCommentsController>(tag: communityId.toString());

    return Obx(() {
      if (communityCommentsController.communityCommentsList.isEmpty) {
        return Center(child: Text('No comments available.'));
      }

      return ListView.builder(
        itemCount: communityCommentsController.communityCommentsList.length,
        itemBuilder: (context, index) {
          final comment =
              communityCommentsController.communityCommentsList[index];
          return ListTile(
            title: Text(
              comment['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              comment['detail'],
              style: TextStyle(fontSize: 16),
            ),
            leading: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(comment['profileImageUrl'])),
            trailing: comment['memberId'] ==
                    int.parse(Get.find<UserController>().userId.value)
                ? IconButton(
                    icon: Icon(
                      Icons.more_horiz_outlined,
                      color: Colors.black,
                      size: 14,
                    ),
                    onPressed: () async {
                      bool? confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('삭제 확인'),
                            content: Text(
                                '이 댓글을 삭제하시겠습니까?'),
                            actions: [
                              TextButton(
                                  child: Text('취소'),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false)),
                              TextButton(
                                  child: Text('삭제'),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true)),
                            ],
                          );
                        },
                      );

                      if (confirmed ?? false) {
                        await communityCommentsController.deleteComment(
                            comment['commentId'], comment['memberId']);
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
