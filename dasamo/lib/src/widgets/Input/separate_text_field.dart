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
        border: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(175, 99, 120, 1))),
        hintText: hintText,
      ),
    );
  }
}
