import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyPageModal extends StatefulWidget {
  final String? profileImageUrl; // URL을 추가
  final File? selectedImage;
  final ValueChanged<File?> onImageChanged;
  final String userName;
  final ValueChanged<String> onUserNameChanged;

  const MyPageModal({
    Key? key,
    this.profileImageUrl, // 추가된 URL
    this.selectedImage,
    required this.onImageChanged,
    required this.userName,
    required this.onUserNameChanged,
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
          // 이미지 표시 부분
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: _image != null
                    ? FileImage(_image!)
                    : widget.profileImageUrl != null
                        ? NetworkImage(widget.profileImageUrl!)
                        : AssetImage('assets/images/default_profile.svg')
                            as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: _image == null && widget.profileImageUrl == null
                ? Center(
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  )
                : null,
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
          // 이름 입력란
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
