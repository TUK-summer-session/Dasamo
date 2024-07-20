import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyPageModal extends StatefulWidget {
  final File? selectedImage;
  final ValueChanged<File?> onImageChanged;
  final String userName;
  final ValueChanged<String> onUserNameChanged;

  const MyPageModal({
    Key? key,
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
  late String _name;

  @override
  void initState() {
    super.initState();
    _image = widget.selectedImage;
    _name = widget.userName;
  }

  @override
  void dispose() {
    // 모달이 닫힐 때 이미지를 기본 이미지로 리셋
    widget.onImageChanged(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
                image: _image == null
                    ? AssetImage('assets/images/profile.jpg')
                    : FileImage(_image!) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.photo_library),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _image = File(pickedFile.path);
                          widget.onImageChanged(_image);
                        });
                      }
                    },
                  ),
                  SizedBox(height: 4),
                  Text('이미지 선택'),
                ],
              ),
              SizedBox(width: 32),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        setState(() {
                          _image = File(pickedFile.path);
                          widget.onImageChanged(_image);
                        });
                      }
                    },
                  ),
                  SizedBox(height: 4),
                  Text('사진 찍기'),
                ],
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
                  controller: TextEditingController(text: _name),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                      widget.onUserNameChanged(_name);
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none, // 테두리 없음
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
              Navigator.of(context).pop(); // 모달 창 닫기
            },
            child: Text('저장'),
          ),
        ],
      ),
    );
  }
}
