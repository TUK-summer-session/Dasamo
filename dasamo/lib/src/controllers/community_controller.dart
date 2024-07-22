import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio; // dio 패키지의 FormData를 dio.FormData로 가져오기
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CommunityController extends GetxController {
  var communityData = <Map<String, dynamic>>[].obs;
  final dio.Dio _dio = dio.Dio();

  @override
  void onInit() {
    super.onInit();
    fetchCommunities();
  }

  Future<void> fetchCommunities() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/community');

    try {
      final response = await http.get(url).timeout(Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;

        if (body.isNotEmpty) {
          final jsonResponse = json.decode(body);

          if (jsonResponse is Map<String, dynamic> &&
              jsonResponse.containsKey('data')) {
            final data = jsonResponse['data'];

            if (data is Map<String, dynamic> &&
                data.containsKey('communities')) {
              final List<dynamic> communities = data['communities'];

              communityData.assignAll(
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
          print('Error: Received empty response');
        }
      } else {
        print('Error: Server returned status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> postCommunity({
    required String memberid,
    required String detail,
    required File? file, // 단일 파일만 처리
  }) async {
    try {
      // POST 요청을 위한 데이터 준비
      final formData = dio.FormData();

      formData.fields.addAll({
        MapEntry('memberid', memberid),
        MapEntry('detail', detail),
      });

      // 파일이 있는 경우 FormData에 추가
      if (file != null) {
        formData.files.add(
          MapEntry(
            'attachment', // 서버에서 기대하는 필드 이름으로 맞추세요
            await dio.MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last, // 파일 이름 추출
            ),
          ),
        );
      }

      // 요청 보내기
      final response = await _dio.post(
        'http://10.0.2.2:3000/api/community', // 실제 API 엔드포인트로 변경
        data: formData,
      );

      // 응답 데이터 출력
      print('Response: ${response.data}');
    } catch (e) {
      if (e is dio.DioException) {
        print("DioException: ${e.message}");
        if (e.response != null) {
          print("Response data: ${e.response?.data}");
        }
      } else {
        print('Error: $e');
      }
    }
  }
}
