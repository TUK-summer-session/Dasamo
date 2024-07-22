import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ReviewController extends GetxController {
  RxList<Map<String, dynamic>> reviewList = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> allReviews = [];
  RxMap<int, Map<String, dynamic>> reviewDetails =
      <int, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/api/reviews'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        final reviews = (data['data']['reviews'] as List).map((review) {
          return {
            'id': review['reviewId'],
            'title': review['title'],
            'description': review['detail'],
            'imageUrl': review['imageUrl'] ?? 'https://via.placeholder.com/150',
            'tagKind': review['tags'].split('/'),
            'like': review['likeCount'],
            'comment': review['questionCount'],
          };
        }).toList();

        allReviews = reviews;
        reviewList.assignAll(reviews);
      } else {
        print('Failed to load reviews');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  Future<void> fetchReviewData(int reviewId) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/api/reviews/$reviewId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        reviewDetails[reviewId] = data;
      } else {
        print('Failed to load review data');
      }
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
    final uri = Uri.parse('http://10.0.2.2:3000/api/reviews'); // API URL을 변경하세요

    final request = http.MultipartRequest('POST', uri)
      ..fields['memberId'] = memberId.toString()
      ..fields['productId'] = productId.toString()
      ..fields['title'] = title
      ..fields['detail'] = detail
      ..fields['score'] = score.toString()
      ..fields['tagIds'] = tagIds.join('/');

    if (imageFile != null) {
      final image = await http.MultipartFile.fromPath('file', imageFile.path);
      request.files.add(image);
    }

    try {
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody.body);
        print('Review submitted successfully: ${responseData['message']}');
        // 리뷰 제출 후 리뷰 목록을 갱신합니다.
        fetchReviews();
      } else {
        print('Failed to submit review: ${responseBody.body}');
      }
    } catch (e) {
      print('Error: $e');
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
}
