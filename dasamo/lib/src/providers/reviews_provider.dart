import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ReviewProvider {
  final String baseUrl = 'http://10.0.2.2:3000/api/reviews';

  Future<List<Map<String, dynamic>>> fetchReviews() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data']['reviews'] as List).map((review) {
        return {
          'id': review['reviewId'],
          'title': review['title'],
          'description': review['detail'],
          'imageFile': review['imageUrl'] ?? 'https://via.placeholder.com/150',
          'tagKind': review['tags'].split('/'),
          'like': review['likeCount'],
          'comment': review['questionCount'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<Map<String, dynamic>> fetchReviewData(int reviewId, int memberId) async {
    final response = await http.get(Uri.parse('$baseUrl/$reviewId').replace(queryParameters: {'memberId': memberId.toString()}));
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load review data');
    }
  }

  Future<void> submitReview({
    required int memberId,
    required String title,
    required String detail,
    required int productId,
    required double score,
    required List<int> tagIds,
    File? imageFile,
  }) async {
    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri)
      ..fields['memberId'] = memberId.toString()
      ..fields['productId'] = productId.toString()
      ..fields['title'] = title
      ..fields['detail'] = detail
      ..fields['score'] = score.toString()
      ..fields['tagIds'] = tagIds.join('/');

    if (imageFile != null) {
      final image = await http.MultipartFile.fromPath('file', imageFile.path);
      request.files.add(image);
    }

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    if (response.statusCode != 200) {
      throw Exception('Failed to submit review: ${responseBody.body}');
    }
  }

  Future<void> deleteReview(int reviewId, String memberId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$reviewId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'memberId': memberId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete review: ${response.body}');
    }
  }

  Future<void> likeReview(int reviewId, int memberId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/like/$reviewId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'memberId': memberId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like review');
    }
  }

  Future<void> unlikeReview(int reviewId, int memberId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/like/$reviewId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'memberId': memberId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unlike review');
    }
  }

  Future<void> bookmarkReview(int reviewId, int memberId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scrap/$reviewId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'memberId': memberId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to bookmark review');
    }
  }

  Future<void> unbookmarkReview(int reviewId, int memberId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/scrap/$reviewId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'memberId': memberId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unbookmark review');
    }
  }
}
