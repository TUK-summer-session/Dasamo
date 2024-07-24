import 'package:dasamo/src/widgets/buttons/buy_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const double _imageSize = 60; // 이미지 크기

class GoodsListItem extends StatefulWidget {
  final Map<String, dynamic> item;
  const GoodsListItem({required this.item, super.key});

  @override
  State<GoodsListItem> createState() => _GoodsListItemState();
}

class _GoodsListItemState extends State<GoodsListItem> {
  bool _buttonHovered = false;

  void _handleBuyButtonTap() async {
    final url = widget.item['purchaseUrl'] ?? '';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // URL이 유효하지 않은 경우에 대한 처리
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100, // 원하는 배경 색상 설정
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20.0), // borderRadius 설정
                    child: Image.network(
                      widget.item['productImageUrl'] ??
                          'https://via.placeholder.com/150',
                      width: _imageSize,
                      height: _imageSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 물건의 브랜드
                              Text(
                                widget.item['brand'] ?? 'Unknown Brand',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold, // 볼드체 적용
                                ),
                              ),
                              // 제품명
                              Text(
                                widget.item['name'] ?? 'Unknown Product',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          BuyButton(
                            purchaseUrl: widget.item['purchaseUrl'],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
