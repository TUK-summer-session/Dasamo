import 'dart:math';

import 'package:dasamo/src/shared/review_data.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  RxList<Map> reviewList = <Map>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initialData();
  }

  _initialData() {
    reviewList.assignAll(reviewData);
  }

  void fetchReviews() {}

  void addData() {
    final random = Random();
    final newItem = {
      'id': random.nextInt(100),
      'title': '제목',
      'description': '설명',
      'imageFile': '/',
      'tagKind': ['태그1', '태그2', '태그3'],
      'like': 100,
      'comment': 100
    };
    reviewList.add(newItem);
  }

  void updateData(Map newData) {
    final id = newData['id'];
    final index = reviewList.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      reviewList[index] = newData;
    }
  }
}
