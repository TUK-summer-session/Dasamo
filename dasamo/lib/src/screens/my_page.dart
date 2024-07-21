import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dasamo/src/screens/alarm_page.dart';
import 'package:dasamo/src/widgets/modal/mypage_modal.dart';
import 'package:dasamo/src/controllers/my_page_tab_controller.dart';
import 'package:dasamo/src/shared/my_page_data.dart'; // 데이터를 가져오기 위해

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final MyPageTabController controller = MyPageTabController();

  // 프로필 정보
  late final ImageProvider _defaultImage;
  late String _userName;

  // 프로필 정보 - 이미지 업로드
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    // 데이터에서 프로필 정보 초기화
    _defaultImage = AssetImage(myPageDataList['profile']['profileImageUrl']);
    _userName = myPageDataList['profile']['name'];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double barWidth = screenWidth / 3; // 3개의 탭 중 선택된 탭의 위치에 맞게 조정
    double barPosition = barWidth * controller.selectedIndex;
    int adjustedIndex = (controller.selectedIndex) % 3;

    // 현재 선택된 탭의 데이터
    List<Map<String, dynamic>> currentTabData;
    if (adjustedIndex == 0) {
      currentTabData =
          List<Map<String, dynamic>>.from(myPageDataList['scraps']);
    } else if (adjustedIndex == 1) {
      currentTabData =
          List<Map<String, dynamic>>.from(myPageDataList['reviews']);
    } else {
      currentTabData =
          List<Map<String, dynamic>>.from(myPageDataList['communities']);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: SizedBox.shrink(),
        leadingWidth: 0,
        title: const Text('마이페이지'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlarmPage()),
              );
            },
            icon: const Icon(Icons.notifications_none_outlined),
          ),
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
                      onTap: () {
                        _showProfileModal();
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: _defaultImage,
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
                      children: [
                        _buildTab('내 리뷰', 0),
                        _buildTab('내 운동', 1),
                        _buildTab('스크랩', 2),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // 이미지 그리드
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemCount: currentTabData.length,
              itemBuilder: (context, index) {
                String imageUrl = currentTabData[index]['imageUrl'];

                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
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
    double tabWidth = screenWidth / 3; // 3개의 탭에 맞춰 조정

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
