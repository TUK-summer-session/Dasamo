import 'dart:io';
import 'package:dasamo/src/screens/review/show.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class MyPageModal extends StatefulWidget {
  final File? selectedImage;
  final ValueChanged<File?> onImageChanged;
  final String userName;
  final ValueChanged<String> onUserNameChanged;
  final String? profileImageUrl;
  final List<Map<String, dynamic>> reviews; // Reviews List 추가

  const MyPageModal({
    Key? key,
    this.selectedImage,
    required this.onImageChanged,
    required this.userName,
    required this.onUserNameChanged,
    this.profileImageUrl,
    required this.reviews, // required
  }) : super(key: key);

  @override
  _MyPageModalState createState() => _MyPageModalState();
}

class _MyPageModalState extends State<MyPageModal> {
  File? _image;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _image = widget.selectedImage;
    _nameController = TextEditingController(text: widget.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '프로필 정보',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // 첫 번째 리뷰로 이동하는 예시
              if (widget.reviews.isNotEmpty) {
                final reviewId = widget.reviews[0]['id']; // 예시로 첫 번째 리뷰의 ID 사용
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewShow(reviewId: reviewId),
                  ),
                );
              }
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: _image != null
                    ? DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      )
                    : widget.profileImageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(widget.profileImageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
              child: _image == null && widget.profileImageUrl == null
                  ? Center(
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    )
                  : null,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImageOption(
                icon: Icons.photo_library,
                label: '이미지 선택',
                source: ImageSource.gallery,
              ),
              SizedBox(width: 32),
              _buildImageOption(
                icon: Icons.camera_alt,
                label: '사진 찍기',
                source: ImageSource.camera,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                child: Text(
                  '이름:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _nameController,
                  onChanged: (value) {
                    widget.onUserNameChanged(value);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('저장'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: () async {
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(source: source);
            if (pickedFile != null) {
              setState(() {
                _image = File(pickedFile.path);
                widget.onImageChanged(_image);
              });
            }
          },
        ),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
