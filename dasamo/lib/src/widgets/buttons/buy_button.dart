import 'package:flutter/material.dart';

class BuyButton extends StatefulWidget {
  final bool buttonHovered;
  final VoidCallback onTap;

  const BuyButton({
    required this.buttonHovered,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _BuyButtonState createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hovered) {
        setState(() {
          _hovered = hovered;
        });
      },
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: 90, // 버튼의 너비
        height: 30, // 버튼의 높이
        decoration: BoxDecoration(
          color: _hovered
              ? Color.fromRGBO(175, 99, 120, 1.0)
              : Color.fromRGBO(175, 99, 120, 0.43),
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center, // 텍스트를 중앙에 정렬
        child: Text(
          '구매하기',
          style: TextStyle(
            fontSize: 20, // 텍스트 크기
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
