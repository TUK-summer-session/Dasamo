import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyButton extends StatelessWidget {
  final String purchaseUrl;

  const BuyButton({
    required this.purchaseUrl,
    Key? key,
  }) : super(key: key);

  Future<void> _handleBuyButtonTap() async {
    final Uri url = Uri.parse(purchaseUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // 웹 브라우저에서 열기
      );
    } else {
      // URL이 유효하지 않은 경우에 대한 처리
      print('Could not launch $purchaseUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _handleBuyButtonTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Color.fromRGBO(175, 99, 120, 1.0),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: Size(90, 30), // 버튼의 너비와 높이
        padding: EdgeInsets.zero, // 패딩을 없애서 버튼 크기를 정확하게 설정
      ),
      child: Container(
        alignment: Alignment.center, // 텍스트를 중앙에 정렬
        child: Text(
          '구매하기',
          style: TextStyle(
            fontSize: 20, // 텍스트 크기
            color: Color.fromRGBO(175, 99, 120, 1.0),
          ),
        ),
      ),
    );
  }
}
