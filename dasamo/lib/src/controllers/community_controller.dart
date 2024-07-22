import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CommunityController extends GetxController {
  var communityList = <Map<String, dynamic>>[].obs;
  final String apiUrl = 'http://10.0.2.2:3000/api/community'; // API URL

  // 커뮤니티 데이터 조회
  Future<void> fetchCommunities() async {
    final int memberId = 1;
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'memberId': memberId,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // ... 나머지 처리
      } else {
        final errorData = json.decode(response.body);
        print(
            'Failed to load communities: ${response.statusCode}, ${errorData['message']}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }
}
