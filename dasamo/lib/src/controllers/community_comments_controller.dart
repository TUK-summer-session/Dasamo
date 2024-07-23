import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CommunityCommentsController extends GetxController {
  RxList<Map<String, dynamic>> communityCommentsList =
      RxList<Map<String, dynamic>>([]);
  final int communityId;

  CommunityCommentsController(this.communityId);

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  // 커뮤니티 댓글 조회
  Future<void> fetchComments() async {
    final url = Uri.parse(
        'http://10.0.2.2:3000/api/community/comments/$communityId'); //

    try {
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null && data['data']['comments'] != null) {
          final questions =
              List<Map<String, dynamic>>.from(data['data']['comments']);
          print('Questions: $questions');

          final filteredQuestions = questions.map((question) {
            return {
              'communityId': question['questionId'],
              'memberId': question['memberId'],
              'name': question['name'],
              'profileImageUrl': question['profileImageUrl'],
              "isCommentForComment": false,
              "parentComment": null,
              'detail': question['detail'],
              'createdAt': question['createdAt'],
              'updatedAt': question['updatedAt'],
            };
          }).toList();

          communityCommentsList.value = filteredQuestions;
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
        Uri.parse('http://10.0.2.2:3000/api/community/comments/$communityId');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "memberId": 1,
      "isCommentForComment": 0, // false
      "parentComment": null,
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

/////////////////
  // 리뷰 댓글 삭제
  Future<void> deleteComment(int questionId, int memberId) async {
    final url =
        Uri.parse('http://10.0.2.2:3000/api/community/comments/$communityId');
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
