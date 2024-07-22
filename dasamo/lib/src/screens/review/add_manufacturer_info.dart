import 'package:dasamo/src/controllers/review/goods_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/widgets/comment/separate_text_field.dart';
import 'package:dasamo/src/widgets/listItems/add_goods_item.dart';
import 'new_review.dart';

class AddManufacturerInfo extends StatefulWidget {
  const AddManufacturerInfo({super.key});

  @override
  State<AddManufacturerInfo> createState() => _AddManufacturerInfoState();
}

class _AddManufacturerInfoState extends State<AddManufacturerInfo> {
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _itemNotFound = false;
  final GoodsController _goodsController = Get.put(GoodsController());

  int? _selectedItemIndex;

  @override
  void initState() {
    super.initState();
    _manufacturerController.addListener(_updateButtonState);
    _productController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final manufacturerText = _manufacturerController.text.trim();
    final productText = _productController.text.trim();

    setState(() {
      _isButtonEnabled =
          (manufacturerText.isNotEmpty && productText.isNotEmpty) ||
              _selectedItemIndex != null;
      _itemNotFound = !_itemExists(manufacturerText, productText);
    });
  }

  bool _itemExists(String manufacturer, String product) {
    return _goodsController.goodsList.any(
      (item) =>
          item['brand']!.toLowerCase() == manufacturer.toLowerCase() &&
          item['name']!.toLowerCase() == product.toLowerCase(),
    );
  }

  void _onItemTap(int index, int originalIndex) {
    setState(() {
      if (_selectedItemIndex == originalIndex) {
        _selectedItemIndex = null;
      } else {
        _selectedItemIndex = originalIndex;
      }
      _isButtonEnabled = true; // Enable button when an item is selected
    });
  }

  @override
  void dispose() {
    _manufacturerController.removeListener(_updateButtonState);
    _productController.removeListener(_updateButtonState);
    _manufacturerController.dispose();
    _productController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInputFields(),
            if (_manufacturerController.text.isNotEmpty ||
                _productController.text.isNotEmpty)
              Obx(() => _buildGoodsList()),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('리뷰 등록하기'),
    );
  }

  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '어떤 제품을 리뷰하실 건가요?',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SeparateTextField(
          controller: _manufacturerController,
          hintText: '이곳을 눌러 제조사를 검색하세요.',
        ),
        SizedBox(height: 20),
        SeparateTextField(
          controller: _productController,
          hintText: '이곳을 눌러 제품명을 검색하세요.',
        ),
        SizedBox(height: 20),
        if (_itemNotFound)
          Text(
            '해당 식품이 없습니다.',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
      ],
    );
  }

  Widget _buildGoodsList() {
    final manufacturerText = _manufacturerController.text.trim().toLowerCase();
    final productText = _productController.text.trim().toLowerCase();

    final filteredGoodsList =
        _goodsController.goodsList.asMap().entries.where((entry) {
      final brand = entry.value['brand']?.toLowerCase() ?? '';
      final name = entry.value['name']?.toLowerCase() ?? '';
      return brand.contains(manufacturerText) && name.contains(productText);
    }).toList();

    return Expanded(
      child: ListView.builder(
        itemCount: filteredGoodsList.length,
        itemBuilder: (context, index) {
          final entry = filteredGoodsList[index];
          final item = entry.value;
          final originalIndex = entry.key;
          final isSelected = _selectedItemIndex == originalIndex;
          return GestureDetector(
            onTap: () => _onItemTap(index, originalIndex),
            child: AddGoodsItem(
              brand: item['brand'] ?? '',
              product: item['name'] ?? '',
              isSelected: isSelected,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!_isButtonEnabled && _selectedItemIndex == null)
          Text(
            '제조사와 제품명을 먼저 입력해주세요.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _isButtonEnabled
              ? () {
                  int? productId;
                  String? brand;

                  if (_selectedItemIndex != null) {
                    final selectedItem =
                        _goodsController.goodsList[_selectedItemIndex!];
                    productId = selectedItem['productId'] as int?;
                    brand = selectedItem['brand'];
                    print(brand);
                    print(productId); // Debugging용으로 출력
                  } else {
                    // 제품이 선택되지 않은 경우 처리 (예: 사용자에게 알림 또는 디폴트 값 설정)
                    // 예를 들어, 다음 코드를 추가할 수 있습니다:
                    // productId = 0; // 또는 적절한 기본값 설정
                    // 또는 오류 메시지 출력
                  }

                  if (productId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewReview(
                          productId: productId,
                        ),
                      ),
                    );
                  } else {
                    // productId가 null인 경우 적절한 처리 (예: 경고 메시지 출력)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('제품을 선택하거나 검색 결과를 확인해 주세요.'),
                      ),
                    );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isButtonEnabled
                ? Color.fromRGBO(175, 99, 120, 1.0)
                : Color.fromRGBO(175, 99, 120, 0.43),
          ),
          child: const Text('다음'),
        ),
      ],
    );
  }
}
