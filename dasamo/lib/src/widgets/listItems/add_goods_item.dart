import 'package:flutter/material.dart';

class AddGoodsItem extends StatelessWidget {
  final String brand;
  final String product;
  final bool isSelected; // 선택 상태를 나타내는 변수

  const AddGoodsItem({
    required this.brand,
    required this.product,
    this.isSelected = false, // 기본값 false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? Color.fromRGBO(175, 99, 120, 0.1)
            : Colors.white, // 선택된 아이템 색상 변경
        border: Border.all(
          color: Colors.grey, // 테두리 색상
          width: 1.0, // 테두리 두께
        ),
        borderRadius: BorderRadius.circular(8), // 테두리 모서리 둥글게
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  product,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
