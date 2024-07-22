import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReviewsCommentsController extends GetxController {
  RxList<Map<String, dynamic>> commentsList = RxList<Map<String, dynamic>>([]);
  final int reviewId;

  ReviewsCommentsController(this.reviewId);

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  // 리뷰 댓글 조회
  Future<void> fetchComments() async {
    final url =
        Uri.parse('http://10.0.2.2:3000/api/reviews/questions/$reviewId');

    try {
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null && data['data']['questions'] != null) {
          final questions =
              List<Map<String, dynamic>>.from(data['data']['questions']);
          print('Questions: $questions');

          final filteredQuestions = questions.map((question) {
            return {
              'questionId': question['questionId'],
              'memberId': question['memberId'],
              'name': question['name'],
              'profileImageUrl': question['profileImageUrl'],
              'detail': question['detail'],
              'createdAt': question['createdAt'],
              'updatedAt': question['updatedAt'],
            };
          }).toList();

          commentsList.value = filteredQuestions;
          print('Filtered Questions: $filteredQuestions');
        } else {
          print('No questions found in the response.');
        }
      } else {
        print('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  // 리뷰 댓글 저장
  Future<void> postComment(String comment) async {
    final url =
        Uri.parse('http://10.0.2.2:3000/api/reviews/questions/$reviewId');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "memberId": 1,
      "isQuestionForQuestion": 0, // false
      "parentQuestion": null,
      "detail": comment
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Comment posted successfully');
        fetchComments(); // 댓글 목록을 다시 불러옵니다.
      } else {
        print('Failed to post comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred while posting comment: $e');
    }
  }

  // 리뷰 댓글 삭제
  Future<void> deleteComment(int questionId, int memberId) async {
    final url =
        Uri.parse('http://10.0.2.2:3000/api/reviews/questions/$questionId');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({"memberId": memberId});

    try {
      final response = await http.delete(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Comment deleted successfully');
        fetchComments(); // 댓글 목록을 다시 불러옵니다.
      } else {
        print('Failed to delete comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred while deleting comment: $e');
    }
  }
}
