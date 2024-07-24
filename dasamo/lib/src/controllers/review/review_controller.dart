import 'dart:io';

import 'package:dasamo/src/providers/reviews_provider.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/user/user_controller.dart';


class ReviewController extends GetxController {
  RxList<Map<String, dynamic>> reviewList = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> allReviews = [];
  RxMap<int, Map<String, dynamic>> reviewDetails = <int, Map<String, dynamic>>{}.obs;

  final UserController userController = Get.put(UserController());
  final ReviewProvider reviewProvider = ReviewProvider();

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      final reviews = await reviewProvider.fetchReviews();
      allReviews = reviews;
      reviewList.assignAll(reviews);
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  Future<void> fetchReviewData(int reviewId) async {
    try {
      final data = await reviewProvider.fetchReviewData(reviewId, int.parse(userController.userId.value));
      reviewDetails[reviewId] = data;
    } catch (e) {
      print('Error fetching review data: $e');
    }
  }

  Future<void> submitReview({
    required int memberId,
    required String title,
    required String detail,
    required int productId,
    required double score,
    required List<int> tagIds,
    File? imageFile,
  }) async {
    try {
      await reviewProvider.submitReview(
        memberId: memberId,
        title: title,
        detail: detail,
        productId: productId,
        score: score,
        tagIds: tagIds,
        imageFile: imageFile,
      );
      fetchReviews();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteReview(int reviewId, String memberId) async {
    try {
      await reviewProvider.deleteReview(reviewId, memberId);
      fetchReviews();
      Get.snackbar('성공', '리뷰가 성공적으로 삭제되었습니다.');
    } catch (e) {
      print('Error: $e');
      Get.snackbar('오류', '리뷰 삭제에 실패했습니다.');
    }
  }

  void filterReviews(String? tag) {
    if (tag == null || tag == '전체') {
      reviewList.assignAll(allReviews);
    } else {
      reviewList.assignAll(allReviews.where((review) {
        return (review['tagKind'] as List).contains(tag);
      }).toList());
    }
  }

  Future<void> likeReview(int reviewId, int memberId) async {
    try {
      await reviewProvider.likeReview(reviewId, memberId);
      if (reviewDetails.containsKey(reviewId)) {
        reviewDetails[reviewId]!['reviewDetail']['isLiked'] = true;
        reviewDetails[reviewId]!['reviewDetail']['likeCount']++;
      }
    } catch (e) {
      print('Error liking review: $e');
    }
  }

  Future<void> unlikeReview(int reviewId, int memberId) async {
    try {
      await reviewProvider.unlikeReview(reviewId, memberId);
      if (reviewDetails.containsKey(reviewId)) {
        reviewDetails[reviewId]!['reviewDetail']['isLiked'] = false;
        reviewDetails[reviewId]!['reviewDetail']['likeCount']--;
      }
    } catch (e) {
      print('Error unliking review: $e');
    }
  }

  Future<void> bookmarkReview(int reviewId, int memberId) async {
    try {
      await reviewProvider.bookmarkReview(reviewId, memberId);
      if (reviewDetails.containsKey(reviewId)) {
        reviewDetails[reviewId]!['reviewDetail']['isBookmarked'] = true;
      }
    } catch (e) {
      print('Error bookmarking review: $e');
    }
  }

  Future<void> unbookmarkReview(int reviewId, int memberId) async {
    try {
      await reviewProvider.unbookmarkReview(reviewId, memberId);
      if (reviewDetails.containsKey(reviewId)) {
        reviewDetails[reviewId]!['reviewDetail']['isBookmarked'] = false;
      }
    } catch (e) {
      print('Error unbookmarking review: $e');
    }
  }
}
