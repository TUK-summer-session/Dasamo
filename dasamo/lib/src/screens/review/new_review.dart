import 'dart:io';

import 'package:dasamo/src/home.dart';
import 'package:dasamo/src/screens/review/index.dart';
import 'package:dasamo/src/shared/review/tag_data.dart';
import 'package:dasamo/src/widgets/buttons/tags/select_tag_button.dart';
import 'package:dasamo/src/widgets/list/star_list_widget.dart';
import 'package:dasamo/src/widgets/modal/more_bottom_modal.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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

  File? _image;
  final ImagePicker _picker = ImagePicker();

  List<int> _selectedTags = []; // 선택된 태그 ID 목록

  Future<void> getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await _picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MoreBottomModal(
          cancelTap: () => Navigator.of(context).pop(),
          cameraTap: () {
            getImage(ImageSource.camera);
            Navigator.of(context).pop();
          },
          galleryTap: () {
            getImage(ImageSource.gallery);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _onTagSelected(int tagId) {
    setState(() {
      if (_selectedTags.contains(tagId)) {
        _selectedTags.remove(tagId);
      } else if (_selectedTags.length < 3) {
        _selectedTags.add(tagId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 등록하기'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildFormContent(),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildStarRating(),
          SizedBox(height: 10),
          _buildTitleField(),
          SizedBox(height: 10),
          _buildContentField(),
          SizedBox(height: 10),
          _buildPhotoArea(),
          SizedBox(height: 10),
          _buildTagSelection(),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '별점을 등록해주세요.',
          style: TextStyle(fontSize: 20),
        ),
        StarListWidget(
          number: 0,
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      cursorColor: Color.fromRGBO(175, 99, 120, 1),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '제목을 입력해주세요.',
        hintStyle: TextStyle(fontSize: 20),
      ),
      maxLines: null, // Allow for multiline input
      keyboardType: TextInputType.multiline,
    );
  }

  Widget _buildContentField() {
    return SizedBox(
      child: TextField(
        controller: _contentController,
        minLines: 3,
        maxLines: null,
        expands: false,
        cursorColor: Color.fromRGBO(175, 99, 120, 1),
        decoration: InputDecoration(
          hintText: '내용을 입력해주세요.',
          hintStyle: TextStyle(fontSize: 16),
          contentPadding: EdgeInsets.all(6), // Padding to position the hintText
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1,
              color: Colors.black, // Default border color
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1,
              color: Color.fromRGBO(175, 99, 120, 1), // Focused border color
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return DottedBorder(
      color: Colors.black,
      strokeWidth: 1.0,
      borderType: BorderType.RRect,
      radius: Radius.circular(12),
      dashPattern: [10, 6],
      child: _image != null ? _buildImagePreview() : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: 360,
      height: 320,
      child: Image.file(_image!),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 360,
      height: 320,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _showImagePickerOptions,
              icon: Icon(
                Icons.image_outlined,
                color: Color.fromRGBO(82, 82, 82, 0.5),
                size: 40, // 아이콘 크기 조정
              ),
              padding: EdgeInsets.all(16), // 버튼 패딩
              constraints: BoxConstraints(
                maxWidth: 80, // 버튼 최대 너비
                maxHeight: 80, // 버튼 최대 높이
              ),
              iconSize: 40, // 아이콘 크기
              color: Color.fromRGBO(82, 82, 82, 0.5),
            ),
            SizedBox(height: 10),
            Text(
              '위 아이콘을 눌러 이미지를 추가해주세요.',
              style: TextStyle(
                  fontSize: 16, color: Color.fromRGBO(82, 82, 82, 0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '태그를 선택해주세요. (최대 3개)',
          style: TextStyle(fontSize: 20),
        ),
        Container(
          height: 34, // Set a fixed height for the ListView
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: tagList.map((tag) {
              final isSelected = _selectedTags.contains(tag['id']);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: SelectTagButton(
                  title: tag['name'],
                  isSelected: isSelected,
                  onTap: () => _onTagSelected(tag['id']),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: () {
          Get.to(Home());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(238, 150, 175, 0.42),
          minimumSize: Size(double.infinity, 50), // 버튼의 최소 너비
        ),
        child: const Text('다음'),
      ),
    );
  }
}
