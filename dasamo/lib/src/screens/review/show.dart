import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/review/review_controller.dart';
import 'package:dasamo/src/controllers/user/user_controller.dart';
import 'package:dasamo/src/widgets/buttons/tags/review_tag_button.dart';
import 'package:dasamo/src/widgets/icons/bookmark_icon.dart';
import 'package:dasamo/src/widgets/icons/comment_icon.dart';
import 'package:dasamo/src/widgets/icons/heart_icon.dart';
import 'package:dasamo/src/widgets/imagepart/review_image.dart';
import 'package:dasamo/src/widgets/listItems/goods_list_item.dart';
import 'package:dasamo/src/widgets/show/show_review_content.dart';
import 'package:dasamo/src/widgets/user/writer_info.dart';
import 'package:dasamo/src/widgets/modal/review_action_sheet.dart';

class ReviewShow extends StatefulWidget {
  final int reviewId;
  const ReviewShow({required this.reviewId, Key? key}) : super(key: key);

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
    final ReviewController reviewController = Get.put(ReviewController());
    await reviewController.fetchReviewData(reviewId);
    return reviewController.reviewDetails[reviewId] ?? {};
  }

  Future<void> toggleLike(bool isLiked) async {
    final ReviewController reviewController = Get.put(ReviewController());
    final UserController userController = Get.put(UserController());
    final memberId = int.parse(userController.userId.value);

    try {
      if (isLiked) {
        await reviewController.unlikeReview(widget.reviewId, memberId);
      } else {
        await reviewController.likeReview(widget.reviewId, memberId);
      }
      // Refresh data after toggling like
      setState(() {
        _reviewData = fetchReviewData(widget.reviewId);
      });
    } catch (e) {
      Get.snackbar('오류', '좋아요 상태를 변경할 수 없습니다.');
    }
  }

  @override
  void dispose() {
    final ReviewController reviewController = Get.find<ReviewController>();
    reviewController.fetchReviews(); // Fetch reviews when popping back
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ReviewController reviewController = Get.put(ReviewController());
    final UserController userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Call fetchReviews before popping back
            reviewController.fetchReviews();
            Navigator.pop(context);
          },
        ),
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
                return Container();
              }

              final isAuthor = snapshot.data!['isAuthor'];

              if (isAuthor) {
                return IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ReviewActionSheet(
                          onDelete: () {
                            final memberId = userController.userId.value;
                            print('User ID: $memberId');
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

        // Determine initial isFavorited based on likeCount
        final isFavorited = reviewDetail['likeCount'] == 1;

        final List<String> tags = reviewDetail['tags'].split('/');

        return ListView(
          children: <Widget>[
            // Profile
            WriterInfo(
              authorName: writer['name'],
              postDate: reviewDetail['createdAt'],
              profileImage: writer['profileImageUrl'],
              starRating: reviewDetail['score'],
            ),

            const SizedBox(height: 10),

            // Review Image
            ReviewImage(
              imageUrl: reviewDetail['imageUrl'],
            ),

            // Heart, Comment, Bookmark
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      HeartIcon(
                        isFavorited: isFavorited,
                        onTap: (isFavorited) {
                          toggleLike(isFavorited);
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
                  // Tag Buttons
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

            // Purchase Button
            GoodsListItem(item: product),

            // Review Content
            ShowReviewContent(item: reviewDetail),
          ],
        );
      }),
    );
  }
}
