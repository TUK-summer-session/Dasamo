import 'package:flutter/material.dart';

class SeparateTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const SeparateTextField({
    required this.controller,
    required this.hintText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: UnderlineInputBorder(), // 하단에만 border 추가
        hintText: hintText,
      ),
    );
  }
}
