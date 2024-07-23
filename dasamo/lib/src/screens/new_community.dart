import 'dart:io';

import 'package:dasamo/src/home.dart';
import 'package:dasamo/src/controllers/community_controller.dart'; // 컨트롤러를 임포트하세요
import 'package:dasamo/src/screens/community_page.dart';
import 'package:dasamo/src/widgets/modal/more_bottom_modal.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class NewCommunity extends StatefulWidget {
  const NewCommunity({super.key, r});

  @override
  State<NewCommunity> createState() => _NewCommunityState();
}

class _NewCommunityState extends State<NewCommunity> {
  final TextEditingController _contentController = TextEditingController();
  final CommunityController _communityController =
      Get.put(CommunityController());

  File? _image;
  final ImagePicker _picker = ImagePicker();

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

  void _submitCommunityPost() async {
    if (_contentController.text.isEmpty) {
      // 내용이 없을 때 처리
      print('내용을 입력하세요');
      return;
    }

    await _communityController.submitFeed(
      memberId: 1, // 실제 멤버 ID로 변경하세요
      detail: _contentController.text,
      imageFile: _image,
    );

    // 성공적으로 제출된 경우, 홈 화면으로 이동
    Get.to(CommunityPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('커뮤니티 등록하기'),
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
          SizedBox(height: 20),
          _buildContentField(),
          SizedBox(height: 40),
          _buildPhotoArea(),
          SizedBox(height: 10),
        ],
      ),
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
          contentPadding: EdgeInsets.all(6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1,
              color: Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1,
              color: Color.fromRGBO(175, 99, 120, 1),
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
                size: 40,
              ),
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(
                maxWidth: 80,
                maxHeight: 80,
              ),
              iconSize: 40,
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

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: _submitCommunityPost,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(238, 150, 175, 0.42),
          minimumSize: Size(double.infinity, 50),
        ),
        child: const Text('다음'),
      ),
    );
  }
}
