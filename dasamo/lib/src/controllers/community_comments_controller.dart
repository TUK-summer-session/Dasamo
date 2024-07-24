import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CommunityCommentsController extends GetxController {
  RxList<Map<String, dynamic>> communityCommentsList = RxList<Map<String, dynamic>>([]);
  final int communityId;

  CommunityCommentsController(this.communityId);

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  Future<void> fetchComments() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/community/comments/$communityId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final comments = List<Map<String, dynamic>>.from(data['data']['comments'] ?? []);
        communityCommentsList.value = comments;
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<void> postComment(int memberId, String comment) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/community/comments/$communityId');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({"memberId": memberId, "isCommentForComment": 0, "parentComment": null, "detail": comment});
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        fetchComments();
      }
    } catch (e) {
      print('Error posting comment: $e');
    }
  }

  Future<void> deleteComment(int commentId, int memberId) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/community/comments/$commentId');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({"memberId": memberId});
    try {
      final response = await http.delete(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        fetchComments();
      }
    } catch (e) {
      print('Error deleting comment: $e');
    }
  }
}

