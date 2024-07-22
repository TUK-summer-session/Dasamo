import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CommentsController extends GetxController {
  RxList<Map<String, dynamic>> commentsList = RxList<Map<String, dynamic>>([]);
  final int reviewId;

  CommentsController(this.reviewId);

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  Future<void> fetchComments() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/community$reviewId');

    try {
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final questions = data['data']['questions'] ?? [];
        final filteredQuestions = questions.map((question) {
          return {
            'questionId': question['questionId'],
            'memberId': question['memberId'],
            'name': question['name'],
            'profileImageUrl': question['profileImageUrl'],
            "isQuestionForQuestion": question['isQuestionForQuestion'], // false
            "parentQuestion": question['parentQuestion'],
            'detail': question['detail'],
            'createdAt': question['createdAt'],
            'updatedAt': question['updatedAt'],
          };
        }).toList();

        commentsList.value = filteredQuestions;
      } else {
        print('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }
}
