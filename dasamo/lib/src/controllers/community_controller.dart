import 'dart:convert';
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
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
      });

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
}
