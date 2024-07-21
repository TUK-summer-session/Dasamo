import 'package:dasamo/src/widgets/Input/separate_text_field.dart';
import 'package:dasamo/src/widgets/listItems/add_goods_item.dart';
import 'package:flutter/material.dart';
import 'new_review.dart'; // NewReview 화면 import

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

  // 선택된 아이템을 저장할 변수
  int? _selectedItemIndex;

  final List<Map<String, String>> _allGoodsItems = [
    {'brandSearch': 'Brand A', 'productSearch': 'Product 1'},
    {'brandSearch': 'Brand B', 'productSearch': 'Product 2'},
    {'brandSearch': 'Brand C', 'productSearch': 'Product 3'},
  ];

  List<Map<String, String>> _filteredGoodsItems = [];

  @override
  void initState() {
    super.initState();
    _filteredGoodsItems = _allGoodsItems;
    _manufacturerController.addListener(_updateButtonState);
    _productController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final manufacturerText = _manufacturerController.text;
    final productText = _productController.text;

    setState(() {
      _isButtonEnabled = manufacturerText.isNotEmpty && productText.isNotEmpty;
      _itemNotFound = !_itemExists(manufacturerText, productText);
      if (manufacturerText.isEmpty || productText.isEmpty) {
        _filteredGoodsItems = [];
      } else {
        _filteredGoodsItems = _allGoodsItems.where((item) {
          final brandMatches = item['brandSearch']!
              .toLowerCase()
              .contains(manufacturerText.toLowerCase());
          final productMatches = item['productSearch']!
              .toLowerCase()
              .contains(productText.toLowerCase());
          return brandMatches && productMatches;
        }).toList();
      }
    });
  }

  bool _itemExists(String manufacturer, String product) {
    return _allGoodsItems.any(
      (item) =>
          item['brandSearch']!.toLowerCase() == manufacturer.toLowerCase() &&
          item['productSearch']!.toLowerCase() == product.toLowerCase(),
    );
  }

  void _onItemTap(int index) {
    setState(() {
      if (_selectedItemIndex == index) {
        _selectedItemIndex = null; // 이미 선택된 아이템을 다시 클릭하면 선택 해제
      } else {
        _selectedItemIndex = index; // 선택된 아이템 업데이트
      }
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
            if (_manufacturerController.text.isNotEmpty &&
                _productController.text.isNotEmpty)
              _buildGoodsList(),
            _buildFooter(context), // context 전달
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
    return Expanded(
      child: ListView.builder(
        itemCount: _filteredGoodsItems.length,
        itemBuilder: (context, index) {
          final item = _filteredGoodsItems[index];
          final isSelected = _selectedItemIndex == index; // 선택된 상태 확인
          return GestureDetector(
            onTap: () => _onItemTap(index), // 아이템 클릭 시 상태 업데이트
            child: AddGoodsItem(
              brand: item['brandSearch'] ?? '',
              product: item['productSearch'] ?? '',
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
        if (!_isButtonEnabled)
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
                  String manufacturer;
                  String product;

                  if (_selectedItemIndex != null) {
                    manufacturer = _filteredGoodsItems[_selectedItemIndex!]
                        ['brandSearch']!;
                    product = _filteredGoodsItems[_selectedItemIndex!]
                        ['productSearch']!;
                  } else {
                    manufacturer = _manufacturerController.text;
                    product = _productController.text;
                  }

                  // NewReview 화면으로 이동하면서 데이터 전달
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewReview(
                        manufacturer: manufacturer,
                        product: product,
                      ),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isButtonEnabled
                ? Color.fromRGBO(175, 99, 120, 1.0) // 활성화 상태 색상
                : Color.fromRGBO(175, 99, 120, 0.43), // 비활성화 상태 색상
          ),
          child: const Text('다음'),
        ),
      ],
    );
  }
}
