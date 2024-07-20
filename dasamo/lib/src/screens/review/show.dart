import 'package:dasamo/src/controllers/goods_controller.dart';
import 'package:dasamo/src/widgets/buttons/review_tag_button.dart';
import 'package:dasamo/src/widgets/icons/bookmark_icon.dart';
import 'package:dasamo/src/widgets/icons/comment_icon.dart';
import 'package:dasamo/src/widgets/icons/heart_icon.dart';
import 'package:dasamo/src/widgets/imagepart/review_image.dart';
import 'package:dasamo/src/widgets/listItems/goods_list_item.dart';
import 'package:dasamo/src/widgets/show/show_review_content.dart';
import 'package:dasamo/src/widgets/user/writer_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// 리뷰 세부페이지
class ReviewShow extends StatefulWidget {
  final Map reviewItem;
  const ReviewShow({required this.reviewItem, super.key});

  @override
  State<ReviewShow> createState() => _ReviewShowState();
}

class _ReviewShowState extends State<ReviewShow> {
  final goodsController = Get.put(GoodsController());

  bool _favoriteTapped = false;
  bool _commentTapped = false;
  bool _bookmarkTapped = false;

  // 태그 데이터 리스트
  final List<String> tags = ['비건', '유기농', '무첨가물'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          // 프로필
          WriterInfo(
            authorName: '작성자',
            postDate: '게시일',
            profileImage: 'assets/images/profile.jpg', // 프로필 이미지 경로
            starRating: 3,
          ),

          // 리뷰 이미지
          ReviewImage(
            imageUrl: 'assets/images/salad.jpg', // 리뷰 이미지 경로
          ),

          // 하트, 댓글 등
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    HeartIcon(
                      isFavorited: _favoriteTapped,
                      onTap: (isFavorited) {
                        setState(() {
                          _favoriteTapped = isFavorited;
                        });
                      },
                    ),
                    SizedBox(width: 5),
                    CommentIcon(),
                    SizedBox(width: 5),
                    BookmarkIcon(
                      isBookmarked: _bookmarkTapped,
                      onTap: (isBookmarked) {
                        setState(() {
                          _bookmarkTapped = isBookmarked;
                        });
                      },
                    ),
                  ],
                ),
                // 태그 버튼 부분
                Row(
                  children: List.generate(tags.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ReviewTagButton(title: tags[index]),
                    );
                  }),
                ),
              ],
            ),
          ),

          // 구매하기
          GoodsListItem(item: widget.reviewItem),

          // 본문
          ShowReviewContent(item: widget.reviewItem),
        ],
      ),
    );
  }
}
