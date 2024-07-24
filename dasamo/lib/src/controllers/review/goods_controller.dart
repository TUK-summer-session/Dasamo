import 'package:dasamo/src/providers/goods_provider.dart';
import 'package:get/get.dart';

class GoodsController extends GetxController {
  RxList<Map<String, dynamic>> goodsList = <Map<String, dynamic>>[].obs;
  final GoodsProvider _goodsProvider = GoodsProvider(); // Create an instance of the provider

  @override
  void onInit() {
    super.onInit();
    fetchGoodsData();
  }

  Future<void> fetchGoodsData() async {
    try {
      final data = await _goodsProvider.fetchGoodsData();
      goodsList.assignAll(data);
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
}
