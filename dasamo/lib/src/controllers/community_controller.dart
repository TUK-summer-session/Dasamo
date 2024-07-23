import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CommunityController extends GetxController {
  var communityList = <Map<String, dynamic>>[].obs;
  final String apiUrl = 'http://10.0.2.2:3000/api/community'; // API URL

  // 커뮤니티 데이터 조회
  Future<void> fetchCommunities(int memberId) async {
    final uri = Uri.parse(apiUrl)
        .replace(queryParameters: {'memberId': memberId.toString()});

    try {
      final response =
          await http.get(uri, headers: {'Accept': 'application/json'});

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];

          if (data is Map<String, dynamic> && data.containsKey('communities')) {
            final List<dynamic> communities = data['communities'];

            communityList.assignAll(
              communities
                  .map((community) => community as Map<String, dynamic>)
                  .toList(),
            );
          } else {
            print('Error: Data field is not as expected');
          }
        } else {
          print('Error: JSON response is not as expected');
        }
      } else {
        final errorData = json.decode(response.body);
        print(
            'Failed to load communities: ${response.statusCode}, ${errorData['message']}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  // 피드 제출
  Future<void> submitFeed({
    required int memberId,
    required String detail,
    File? imageFile,
  }) async {
    final uri = Uri.parse(apiUrl); // API URL을 변경하세요

    final request = http.MultipartRequest('POST', uri)
      ..fields['memberId'] = memberId.toString()
      ..fields['detail'] = detail;

    // 파일이 있는 경우, multipart/form-data 형식으로 파일을 추가
    if (imageFile != null) {
      final image = await http.MultipartFile.fromPath('file', imageFile.path);
      request.files.add(image);
    }

    try {
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      print('커뮤니티 저장: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody.body);
        print('Feed submitted successfully: ${responseData['message']}');
        // 피드 제출 후 피드 목록을 갱신합니다.
        await fetchCommunities(memberId); // 피드 목록을 다시 불러옵니다.
      } else {
        print('Failed to submit feed: ${responseBody.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

// 커뮤니티 댓글 좋아요
  Future<void> likeCommunityComment({
    required int communityId,
    required int memberId,
  }) async {
    final uri =
        Uri.parse('http://10.0.2.2:3000/api/community/like/$communityId');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json', // JSON 데이터임을 명시
        },
        body: json.encode({'memberId': memberId}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('커뮤니티 좋아요 성공: ${jsonResponse['message']}');
      } else if (response.statusCode == 401) {
        final jsonResponse = json.decode(response.body);
        print('이미 좋아요 한 게시글입니다: ${jsonResponse['message']}');
      } else {
        print('Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  // 커뮤니티 댓글 좋아요 취소
  Future<void> unlikeCommunityComment({
    required int communityId,
    required int memberId,
  }) async {
    final uri =
        Uri.parse('http://10.0.2.2:3000/api/community/like/$communityId');

    try {
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json', // JSON 데이터임을 명시
        },
        body: json.encode({'memberId': memberId}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('커뮤니티 좋아요 취소 성공: ${jsonResponse['message']}');
      } else if (response.statusCode == 401) {
        final jsonResponse = json.decode(response.body);
        print('이미 좋아요 취소된 게시글입니다: ${jsonResponse['message']}');
      } else {
        print('Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }
}
