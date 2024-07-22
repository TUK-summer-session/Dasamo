import 'package:dasamo/src/controllers/review/review_controller.dart';
import 'package:dasamo/src/widgets/buttons/tags/review_tag_button.dart';
import 'package:dasamo/src/widgets/icons/bookmark_icon.dart';
import 'package:dasamo/src/widgets/icons/comment_icon.dart';
import 'package:dasamo/src/widgets/icons/heart_icon.dart';
import 'package:dasamo/src/widgets/imagepart/review_image.dart';
import 'package:dasamo/src/widgets/listItems/goods_list_item.dart';
import 'package:dasamo/src/widgets/show/show_review_content.dart';
import 'package:dasamo/src/widgets/user/writer_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewShow extends StatelessWidget {
  final int reviewId;
  const ReviewShow({required this.reviewId, super.key});

  @override
  Widget build(BuildContext context) {
    final ReviewController reviewController = Get.find();

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
      body: Obx(() {
        if (!reviewController.reviewDetails.containsKey(reviewId)) {
          reviewController.fetchReviewData(reviewId);
          return Center(child: CircularProgressIndicator());
        }

        final reviewData = reviewController.reviewDetails[reviewId];
        if (reviewData == null) {
          return Center(child: Text('Failed to load review data'));
        }

        final reviewDetail = reviewData['reviewDetail'];
        final product = reviewData['product'];
        final writer = reviewData['writer'];

        final List<String> tags = reviewDetail['tags'].split('/');

        return ListView(
          children: <Widget>[
            // 프로필
            WriterInfo(
              authorName: writer['name'],
              postDate: reviewDetail['createdAt'],
              profileImage: writer['profileImageUrl'], // 프로필 이미지 경로
              starRating: reviewDetail['score'],
            ),

            const SizedBox(height: 10),

            // 리뷰 이미지
            ReviewImage(
              imageUrl: reviewDetail['imageUrl'], // 리뷰 이미지 경로
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
                        isFavorited: reviewDetail['isLiked'],
                        onTap: (isFavorited) {
                          // Handle favorite tap
                        },
                      ),
                      SizedBox(width: 5),
                      CommentIcon(),
                      SizedBox(width: 5),
                      BookmarkIcon(
                        isBookmarked: reviewDetail['isScraped'],
                        onTap: (isBookmarked) {
                          // Handle bookmark tap
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
            GoodsListItem(item: product),

            // 본문
            ShowReviewContent(item: reviewDetail),
          ],
        );
      }),
    );
  }
}
