import 'dart:math';

import 'package:dasamo/src/shared/goods_data.dart';
import 'package:dasamo/src/shared/review_data.dart';
import 'package:get/get.dart';

class GoodsController extends GetxController {
  RxList<Map> goodsList = <Map>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initialData();
  }

  _initialData() {
    goodsList.assignAll(goodsItems);
  }

  void addData() {
    final random = Random();
    final newItem = {
      'id': random.nextInt(100),
      'brandSearch': '제조사',
      'productSearch': '제품명',
      'image': '/',
      'price': 10000,
      'calorie': "100kcal",
    };
    goodsList.add(newItem);
  }

  void updateData(Map newData) {
    final id = newData['id'];
    final index = goodsList.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      goodsList[index] = newData;
    }
  }
}
