import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MyPageController extends GetxController {
  var profileData = {}.obs;
  var scraps = <Map<String, dynamic>>[].obs;
  var reviews = <Map<String, dynamic>>[].obs;
  var communities = <Map<String, dynamic>>[].obs;

  final int memberId;

  MyPageController(this.memberId);

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    // 실제 API URL로 변경해야 합니다.
    final Uri url = Uri.parse('http://10.0.2.2:3000/api/members/mypage')
        .replace(queryParameters: {'memberId': memberId.toString()});

    try {
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body!!!: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;

        // 'data' 필드가 Map 타입인지 확인하고 처리합니다.
        if (data['data'] is Map<String, dynamic>) {
          final Map<String, dynamic> dataContent =
              data['data'] as Map<String, dynamic>;

          // 'profile'을 List로 처리합니다.
          final profileList = dataContent['profile'] as List<dynamic>?;

          if (profileList != null && profileList.isNotEmpty) {
            final profile = profileList.first as Map<String, dynamic>;
            profileData.value = profile;
          } else {
            profileData.value = {}; // 기본 값 설정
          }

          // 'scraps', 'reviews', 'communities'를 List로 처리합니다.
          scraps.value =
              List<Map<String, dynamic>>.from(dataContent['scraps'] ?? []);
          reviews.value =
              List<Map<String, dynamic>>.from(dataContent['reviews'] ?? []);
          communities.value =
              List<Map<String, dynamic>>.from(dataContent['communities'] ?? []);
        } else {
          print('예상한 Map 타입이 아닙니다: ${data['data'].runtimeType}');
        }
      } else {
        print('데이터를 불러오는데 실패했습니다: ${response.statusCode}');
      }
    } catch (e) {
      print('데이터를 불러오는 도중 오류가 발생했습니다: $e');
    }
  }
}
