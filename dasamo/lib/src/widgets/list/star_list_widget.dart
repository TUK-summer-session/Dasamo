import 'package:flutter/material.dart';

class StarListWidget extends StatelessWidget {
  final int number;

  const StarListWidget({Key? key, this.number = 1})
      : super(key: key); // number=1은 기본값

  @override
  Widget build(BuildContext context) {
    List<Widget> images = [];

    // number 변수에 따라 이미지 추가
    for (int i = 0; i < number; i++) {
      images.add(
        Container(
          width: 40,
          height: 20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/sweet_potato1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < 5 - number; i++) {
      images.add(
        Container(
          width: 40,
          height: 20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/sweet_potato2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return Row(
      children: images,
    );
  }
}
