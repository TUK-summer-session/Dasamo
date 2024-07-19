import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/community_controller.dart';
import 'package:dasamo/src/widgets/Input/comment_input.dart';
import 'package:dasamo/src/widgets/Input/comments.dart';
import 'package:dasamo/src/widgets/expand/expand_text.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  // 아이콘 hover
  bool _favoriteHovered = false;
  bool _favoriteTapped = false;

  bool _commentHovered = false;
  bool _commentTapped = false;

  final CommunityController communityController =
      Get.put(CommunityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: SizedBox.shrink(),
        leadingWidth: 0,
        title: const Text('커뮤니티'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: communityController.communityList.map((comment) {
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
                                  image: AssetImage(comment['profileImage']),
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
                                    comment['author'],
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    comment['date'],
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

                  // 리뷰 이미지
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(comment['image']),
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
                              onTap: () {
                                setState(() {
                                  _favoriteTapped = !_favoriteTapped;
                                });
                                print('Bookmark 아이콘을 탭했습니다.');
                              },
                              child: _favoriteTapped
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      _favoriteHovered
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          _favoriteHovered ? Colors.red : null,
                                    ),
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              onHover: (hovered) {
                                setState(() {
                                  _commentHovered = hovered;
                                });
                              },
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    double screenHeight =
                                        MediaQuery.of(context).size.height;
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      height: screenHeight * 0.7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      height: 5,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                    ),
                                                  ),
                                                  Comments(), // Comments widget
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: CommentInput(
                                              onSave: (comment) {
                                                communityController.addComment({
                                                  'profileImage':
                                                      'assets/images/profile_new.jpg',
                                                  'author': 'New User',
                                                  'date': '2024-07-21',
                                                  'image':
                                                      'assets/images/salad.jpg',
                                                  'text': comment,
                                                });
                                                print('저장된 댓글: $comment');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                                print('Comment 아이콘을 탭했습니다.');
                              },
                              child: Icon(
                                _commentHovered
                                    ? Icons.chat_bubble
                                    : Icons.chat_bubble_outline,
                                color: _commentHovered
                                    ? Color.fromRGBO(175, 99, 120, 1.0)
                                    : null,
                              ),
                            ),
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
                          text: comment['text'],
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
