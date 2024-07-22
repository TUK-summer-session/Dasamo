import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class GoodsController extends GetxController {
  RxList<Map> goodsList = <Map>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchGoodsData();
  }

  Future<void> fetchGoodsData() async {
    final url = 'http://10.0.2.2:3000/api/reviews/products';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data =
            json.decode(response.body)['data']['products'];
        goodsList.assignAll(data
            .map((item) => {
                  'productId': item['productId'],
                  'brand': item['brand'],
                  'name': item['name'],
                })
            .toList());
      } else {
        print('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
}
