import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dasamo/src/controllers/review/review_controller.dart';
import 'package:dasamo/src/home.dart';
import 'package:dasamo/src/models/tag.dart';
import 'package:dasamo/src/widgets/buttons/tags/select_tag_button.dart';
import 'package:dasamo/src/widgets/list/star_widget.dart';
import 'package:dasamo/src/widgets/modal/more_bottom_modal.dart';
import 'package:dotted_border/dotted_border.dart';

class NewReview extends StatefulWidget {
  final int? productId;

  const NewReview({
    super.key,
    required this.productId,
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
  List<Tag> tagList = []; // 태그 목록
  final ReviewController _reviewController = Get.find<ReviewController>();

  @override
  void initState() {
    super.initState();
    _fetchTags(); // 태그 데이터를 가져옵니다.
  }

  Future<void> _fetchTags() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/api/tag'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> tagsJson = data['data']['tags'];
        setState(() {
          tagList = tagsJson.map((json) => Tag.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      print('Error fetching tags: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('태그를 불러오는 데 실패했습니다.')),
      );
    }
  }

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

  Future<void> _submitReview() async {
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _selectedTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 채워주세요.')),
      );
      return;
    }

    final score = 5.0; // StarWidget에서 선택한 별점 값을 가져와야 합니다.
    final productId = widget.productId; // 전달받은 productId

    if (productId != null) {
      await _reviewController.submitReview(
        memberId: 1,
        title: _titleController.text,
        detail: _contentController.text,
        productId: productId,
        score: score,
        tagIds: _selectedTags,
        imageFile: _image,
      );

      Get.to(Home()); // 리뷰 제출 후 홈으로 돌아가기
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('유효한 제품 ID를 제공해 주세요.')),
      );
    }
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
          '별점을 매겨주세요.',
          style: TextStyle(fontSize: 20),
        ),
        StarWidget(
          initialRating: 1,
          onRatingChanged: (rating) {
            // 별점이 변경되었을 때의 동작을 여기에 구현합니다.
            print('Selected Rating: $rating');
          },
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
              final isSelected = _selectedTags.contains(tag.id);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: SelectTagButton(
                  title: tag.name,
                  isSelected: isSelected,
                  onTap: () => _onTagSelected(tag.id),
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
        onPressed: _submitReview,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(238, 150, 175, 0.42),
          minimumSize: Size(double.infinity, 50), // 버튼의 최소 너비
        ),
        child: const Text('다음'),
      ),
    );
  }
}
