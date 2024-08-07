import 'package:dasamo/src/screens/review/show.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/review/review_controller.dart';
import 'package:dasamo/src/screens/review/add_manufacturer_info.dart';
import 'package:dasamo/src/widgets/buttons/tags/tag_button.dart';
import 'package:dasamo/src/widgets/listItems/review_list_item.dart';
import 'package:dasamo/src/shared/review/tag_data.dart';

class ReviewIndex extends StatefulWidget {
  const ReviewIndex({super.key});

  @override
  State<ReviewIndex> createState() => _ReviewIndexState();
}

class _ReviewIndexState extends State<ReviewIndex> {
  String? _selectedTag = '전체';
  final ReviewController reviewController = Get.put(ReviewController());

  void _onTagSelected(String tag) {
    setState(() {
      _selectedTag = _selectedTag == tag ? null : tag;
    });
    reviewController.filterReviews(_selectedTag);
  }

  Future<void> _navigateToReviewShow(int reviewId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewShow(reviewId: reviewId)),
    );

    if (result == true) {
      // 새로고침 필요
      reviewController.fetchReviews(); // 리뷰 목록 새로 고침
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddManufacturerInfo()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        title: const Text('리뷰'),
        leading: SizedBox.shrink(),
        leadingWidth: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: tagList.map((tag) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: TagButton(
                      title: tag['name'],
                      isSelected: _selectedTag == tag['name'],
                      onTap: () => _onTagSelected(tag['name']),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: reviewController.reviewList.length,
                itemBuilder: (context, index) {
                  final item = reviewController.reviewList[index];
                  return ReviewListItem(item);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
