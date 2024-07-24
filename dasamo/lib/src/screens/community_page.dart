import 'package:dasamo/src/controllers/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/community_controller.dart';
import 'package:dasamo/src/screens/new_community.dart';
import 'package:dasamo/src/widgets/expand/expand_text.dart';
import 'package:dasamo/src/widgets/icons/community_comment_icon.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final CommunityController communityController =
      Get.put(CommunityController());
  bool _favoriteHovered = false;
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    // 데이터 초기 로드 (memberId를 적절히 설정)
    final memberId =
        int.parse(userController.userId.value); // 실제 memberId를 이곳에 설정합니다.
    communityController.fetchCommunities(memberId);
  }

  Future<void> _toggleLike(Map<String, dynamic> community) async {
    final int communityId = community['communityId'];
    final memberId =
        int.parse(userController.userId.value); // 실제 memberId를 이곳에 설정합니다.

    try {
      if (community['isLiked']) {
        await communityController.unlikeCommunityComment(
          communityId: communityId,
          memberId: memberId,
        );
      } else {
        await communityController.likeCommunityComment(
          communityId: communityId,
          memberId: memberId,
        );
      }

      setState(() {
        community['isLiked'] = !community['isLiked'];
      });
    } catch (e) {
      print('Error toggling like status: $e');
    }
  }

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
      ),
      body: Obx(() {
        if (communityController.communityList.isEmpty) {
          return Center(
            child: Text('데이터가 없습니다.'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: communityController.communityList.map((community) {
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
                          image: NetworkImage(image['url'] ?? ''),
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
                              onHover: (hovered) {
                                setState(() {
                                  _favoriteHovered = hovered;
                                });
                              },
                              onTap: () async {
                                await _toggleLike(community);
                                print('하트 아이콘을 탭했습니다.');
                              },
                              child: Icon(
                                community['isLiked']
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: community['isLiked'] || _favoriteHovered
                                    ? Colors.red
                                    : null,
                              ),
                            ),
                            SizedBox(width: 5),
                            CommunityCommentIcon(communityId: communityId),
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
