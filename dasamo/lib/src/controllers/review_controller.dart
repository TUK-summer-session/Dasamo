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

  void addData() {}
  void updateData() {}
}
