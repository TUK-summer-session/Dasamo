import 'dart:io';
import 'package:dasamo/src/widgets/modal/mypage_modal.dart';
import 'package:flutter/material.dart';
import 'package:dasamo/src/controllers/my_page_tab_controller.dart';
import 'package:dasamo/src/shared/tab_data.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final MyPageTabController controller = MyPageTabController();

  // 프로필 정보 - 이미지 업로드
  File? _selectedImage;
  final ImageProvider _defaultImage = AssetImage('assets/images/profile.jpg');

  // 프로필 정보 - 이름
  String _userName = '작성자'; // 기본 사용자 이름

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double barWidth = screenWidth / tabDataList.length;
    double barPosition = barWidth * controller.selectedIndex;
    final currentTabData = tabDataList[controller.selectedIndex];

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: SizedBox.shrink(),
        leadingWidth: 0,
        title: const Text('마이페이지'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 프로필
            Container(
              padding: EdgeInsets.fromLTRB(40, 30, 0, 20),
              child: Row(
                children: <Widget>[
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _showProfileModal,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/profile.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 텍스트 및 바
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: barPosition,
                    bottom: 0,
                    child: Container(
                      height: 5,
                      width: barWidth,
                      color: Color.fromRGBO(175, 99, 120, 1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: tabDataList.asMap().entries.map((entry) {
                        return _buildTab(
                          entry.value.title,
                          entry.key,
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),

            // 추가 이미지나 콘텐츠
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemCount: currentTabData.images.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(currentTabData.images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tabWidth = screenWidth / tabDataList.length;

    return GestureDetector(
      onTap: () {
        setState(() {
          controller.setSelectedIndex(index);
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: tabWidth,
          height: 50,
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: controller.selectedIndex == index
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  void _showProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return MyPageModal(
          selectedImage: _selectedImage,
          onImageChanged: (image) {
            setState(() {
              _selectedImage = image;
            });
          },
          userName: _userName,
          onUserNameChanged: (name) {
            setState(() {
              _userName = name;
            });
          },
        );
      },
    );
  }
}
