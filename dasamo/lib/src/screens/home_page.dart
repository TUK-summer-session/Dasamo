// 홈 페이지 위젯
import 'package:dasamo/src/controllers/review_controller.dart';
import 'package:dasamo/src/shared/tag_data.dart';
import 'package:dasamo/src/widgets/buttons/tag_button.dart';
import 'package:dasamo/src/widgets/listItems/review_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedTag;
  final reviewController = Get.put(ReviewController());

  void _onTagSelected(String tag) {
    setState(() {
      _selectedTag = _selectedTag == tag ? null : tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color.fromRGBO(175, 99, 120, 1),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        leading: Icon(Icons.menu),
        title: const Text('리뷰'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined))
        ],
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
                  }).toList()),
            ),
          ),
          Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: reviewController.reviewList.length,
                    itemBuilder: (context, index) {
                      final item = reviewController.reviewList[index];
                      return ReviewListItem(item);
                    },
                  )))
        ],
      ),
    );
  }
}
