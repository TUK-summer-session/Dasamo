import 'package:flutter/material.dart';

class ReviewTagButton extends StatelessWidget {
  final String? title;

  const ReviewTagButton({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black)),
        child: Row(
          children: [
            Text(
              title ?? '',
              style: TextStyle(fontSize: 14, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
