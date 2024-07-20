import 'package:dasamo/src/controllers/review_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewEdit extends StatefulWidget {
  final Map item;
  const ReviewEdit({required this.item, super.key});

  @override
  State<ReviewEdit> createState() => _ReviewEditState();
}

class _ReviewEditState extends State<ReviewEdit> {
  final revieController = Get.find<ReviewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.item['title']),
      ),
    );
  }
}
