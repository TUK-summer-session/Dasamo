import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CommunityController extends GetxController {
  var communityData = <Map<String, dynamic>>[].obs; // 데이터를 직접 저장하는 리스트

  @override
  void onInit() {
    super.onInit();
    fetchCommunityData();
  }

  Future<void> fetchCommunityData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/api/community'));

      print('Response status!!: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final communities = (data['communities'] as List).map((community) {
          return {
            'communityId': community['communityId'],
            'detail': community['detail'],
            'createdAt': community['createdAt'],
            'updatedAt': community['updatedAt'],
            'member': {
              'memberId': community['member']['memberId'],
              'email': community['member']['email'],
              'name': community['member']['name'],
              'profileImageUrl': community['member']['profileImageUrl'] ??
                  'https://via.placeholder.com/150',
            }
          };
        }).toList();

        print('Parsed communities: $communities');
        communityData.assignAll(communities); // 데이터를 리스트에 할당
      } else {
        print('Failed to load communities');
      }
    } catch (e) {
      print('Error fetching communities: $e');
    }
  }
}
