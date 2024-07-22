import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/community_controller.dart';
import 'package:dasamo/src/controllers/reviews_comments_controller.dart';
import 'package:dasamo/src/screens/new_community.dart';
import 'package:dasamo/src/screens/alarm_page.dart';
import 'package:dasamo/src/widgets/modal/comment_modal.dart';
import 'package:dasamo/src/widgets/expand/expand_text.dart';

class CommunityPage extends StatelessWidget {
  final CommunityController communityController =
      Get.put(CommunityController());

  CommunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'addTag2',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewCommunity()),
          );
        },
        backgroundColor: Color.fromRGBO(175, 99, 120, 1),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        leading: SizedBox.shrink(),
        leadingWidth: 0,
        title: const Text('커뮤니티'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlarmPage()),
              );
            },
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      body: Obx(() {
        if (communityController.communityData.isEmpty) {
          return Center(
            child: Text('데이터가 없습니다.'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: communityController.communityData.map((community) {
              final int communityId = community['communityId'];
              final member = community['member'];
              final image = community['image'];

              if (member == null) {
                return SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 프로필
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      member['profileImageUrl'] ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member['name'] ?? '',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    community['createdAt'] ?? '',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 커뮤니티 이미지 (옵션)
                  if (image != null &&
                      image['url'] != null &&
                      image['url'].isNotEmpty)
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(image['url']),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0.5,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),

                  // 하트, 댓글 등
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 20, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                print(
                                    'Heart icon tapped for communityId: $communityId');
                              },
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 5),
                            // InkWell(
                            //   onTap: () {
                            //     final commentsController =
                            //         CommentsController(communityId);
                            //     commentsController.fetchComments();

                            //     showModalBottomSheet(
                            //       context: context,
                            //       isScrollControlled: true,
                            //       builder: (context) => CommentModal(
                            //         commentsController: commentsController,
                            //         reviewId: 1234,
                            //       ),
                            //     );
                            //     print(
                            //         'Comment icon tapped for communityId: $communityId');
                            //   },
                            //   child: Icon(
                            //     Icons.chat_bubble_outline,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 확장 텍스트
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpandText(
                          text: community['detail'] ?? '',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
