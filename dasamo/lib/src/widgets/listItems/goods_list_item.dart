import 'package:dasamo/src/widgets/buttons/buy_button.dart';
import 'package:flutter/material.dart';
import 'package:dasamo/src/widgets/buttons/review_tag_button.dart';
import 'package:get/get.dart';

const double _imageSize = 90;

class GoodsListItem extends StatefulWidget {
  final Map item;
  const GoodsListItem({required this.item, super.key});

  @override
  State<GoodsListItem> createState() => _GoodsListItemState();
}

class _GoodsListItemState extends State<GoodsListItem> {
  bool _buttonHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=1075&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  width: _imageSize,
                  height: _imageSize,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 물건의 브랜드
                          Text(
                            widget.item['brandSearch'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold, // 볼드체 적용
                            ),
                          ),
                          // 제품명
                          Text(
                            widget.item['productSearch'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      BuyButton(
                        buttonHovered: _buttonHovered,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
