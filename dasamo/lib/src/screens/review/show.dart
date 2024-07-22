import 'package:dasamo/src/controllers/user/user_controller.dart';
import 'package:dasamo/src/widgets/modal/review_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/review/review_controller.dart';
import 'package:dasamo/src/widgets/buttons/tags/review_tag_button.dart';
import 'package:dasamo/src/widgets/icons/bookmark_icon.dart';
import 'package:dasamo/src/widgets/icons/comment_icon.dart';
import 'package:dasamo/src/widgets/icons/heart_icon.dart';
import 'package:dasamo/src/widgets/imagepart/review_image.dart';
import 'package:dasamo/src/widgets/listItems/goods_list_item.dart';
import 'package:dasamo/src/widgets/show/show_review_content.dart';
import 'package:dasamo/src/widgets/user/writer_info.dart';

class ReviewShow extends StatefulWidget {
  final int reviewId;
  const ReviewShow({required this.reviewId, super.key});

  @override
  State<ReviewShow> createState() => _ReviewShowState();
}

class _ReviewShowState extends State<ReviewShow> {
  late Future<Map<String, dynamic>> _reviewData;

  @override
  void initState() {
    super.initState();
    _reviewData = fetchReviewData(widget.reviewId);
  }

  Future<Map<String, dynamic>> fetchReviewData(int reviewId) async {
    final ReviewController reviewController = Get.find();
    await reviewController.fetchReviewData(reviewId);
    return reviewController.reviewDetails[reviewId] ?? {};
  }

  @override
  Widget build(BuildContext context) {
    final ReviewController reviewController = Get.find();
    final UserController userController = Get.find();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          FutureBuilder<Map<String, dynamic>>(
            future: _reviewData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Failed to load data'));
              }

              if (!snapshot.hasData ||
                  !snapshot.data!.containsKey('isAuthor')) {
                return Container(); // Or some other widget indicating data is not available
              }

              final isAuthor = snapshot.data!['isAuthor'];

              if (isAuthor) {
                return IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ReviewActionSheet(
                          onEdit: () {
                            // Handle edit action
                            print("Edit action");
                          },
                          onDelete: () {
                            final memberId = userController.userId.value;
                            reviewController.deleteReview(
                                widget.reviewId, memberId);
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_horiz_outlined),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (!reviewController.reviewDetails.containsKey(widget.reviewId)) {
          reviewController.fetchReviewData(widget.reviewId);
          return Center(child: CircularProgressIndicator());
        }

        final reviewData = reviewController.reviewDetails[widget.reviewId];
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
