import 'package:dasamo/src/widgets/list/star_list_widget.dart';
import 'package:flutter/material.dart';

class NewReview extends StatefulWidget {
  final String manufacturer;
  final String product;

  const NewReview({
    super.key,
    required this.manufacturer,
    required this.product,
  });

  @override
  State<NewReview> createState() => _NewReviewState();
}

class _NewReviewState extends State<NewReview> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 등록하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '별점을 등록해주세요.',
                  style: TextStyle(fontSize: 20),
                ),
                StarListWidget(
                  number: 0,
                )
              ],
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '제목을 입력해주세요.',
                hintStyle: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10), // Title과 Content 사이에 공간 추가
            Container(
              height: 90,
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: '내용을 입력해주세요.',
                  hintStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
