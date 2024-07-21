import 'package:flutter/material.dart';

class SelectTagButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final bool isSelected;

  const SelectTagButton({
    required this.title,
    this.onTap,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromRGBO(175, 99, 120, 0.43) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            title ?? '',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
