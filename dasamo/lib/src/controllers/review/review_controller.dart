import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  RxList<Map<String, dynamic>> reviewList = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> allReviews = [];

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/reviews'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reviews = (data['data']['reviews'] as List).map((review) {
          return {
            'id': review['reviewId'],
            'title': review['title'],
            'description': review['detail'],
            'imageFile': review['imageUrl'] ?? 'https://via.placeholder.com/150',
            'tagKind': review['tags'].split('/'),
            'like': review['likeCount'],
            'comment': review['questionCount'],
            'writer': 'Unknown',
            'creationDate': 'Unknown'
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

  // void addData() {
  //   final random = Random();
  //   final newItem = {
  //     'id': random.nextInt(100),
  //     'title': '제목',
  //     'description': '설명',
  //     'imageFile': 'https://via.placeholder.com/150', // 기본 이미지 URL
  //     'tagKind': ['태그1', '태그2', '태그3'],
  //     'like': 100,
  //     'comment': 100
  //   };
  //   reviewList.add(newItem);
  // }

  // void updateData(Map<String, dynamic> newData) {
  //   final id = newData['id'];
  //   final index = reviewList.indexWhere((item) => item['id'] == id);
  //   if (index != -1) {
  //     reviewList[index] = newData;
  //   }
  // }

