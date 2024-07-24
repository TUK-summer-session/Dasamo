import 'dart:convert';
import 'package:http/http.dart' as http;

class GoodsProvider {
  final String _baseUrl = 'http://10.0.2.2:3000/api/reviews/products';

  Future<List<Map<String, dynamic>>> fetchGoodsData() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data =
            json.decode(response.body)['data']['products'];
        return data.map((item) => {
              'productId': item['productId'],
              'brand': item['brand'],
              'name': item['name'],
            }).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }
}
