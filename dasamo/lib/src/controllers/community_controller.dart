import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CommunityController extends GetxController {
  var communityData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCommunities();
  }

  Future<void> fetchCommunities() async {
    final url = Uri.parse('http://localhost:3000/api/community');

    try {
      final response = await http.get(url).timeout(Duration(seconds: 10));

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
}
