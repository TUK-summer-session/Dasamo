import 'package:dasamo/src/shared/comments_data.dart';
import 'package:get/get.dart';

class CommentsController extends GetxController {
  RxList<Map<String, dynamic>> commentsList = RxList<Map<String, dynamic>>([]);

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  void fetchComments() {
    // commentsData에서 questions 리스트를 가져옵니다.
    final List<Map<String, dynamic>> questions =
        commentsData.isNotEmpty ? commentsData.first['questions'] ?? [] : [];
    commentsList.value = questions;
  }
}
