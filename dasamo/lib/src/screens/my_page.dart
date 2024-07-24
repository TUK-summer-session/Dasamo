import 'dart:io';
import 'package:dasamo/src/controllers/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dasamo/src/controllers/mypage_controller.dart';
import 'package:dasamo/src/controllers/user/user_controller.dart';
import 'package:dasamo/src/widgets/modal/mypage_modal.dart';
import 'package:dasamo/src/controllers/my_page_tab_controller.dart';
import 'package:dasamo/src/screens/review/show.dart'; // 파일 경로 확인

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final MyPageTabController tabController = MyPageTabController();
  late MyPageController myPageController;
  final UserController userController = Get.find();

  // 프로필 정보
  ImageProvider? _defaultImage;
  String? _userName;

  // 프로필 정보 - 이미지 업로드
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    final memberId = int.parse(userController.userId.value);
    myPageController = Get.put(MyPageController(memberId));

    // 데이터 로딩 후 상태 업데이트
    myPageController.profileData.listen((profileData) {
      if (profileData != null && profileData.isNotEmpty) {
        final profileImageUrl = profileData['profileImageUrl'] as String?;
        final name = profileData['name'] as String?;

        setState(() {
          _defaultImage = profileImageUrl != null
              ? NetworkImage(profileImageUrl)
              : AssetImage('assets/default_profile.png');
          _userName = name ?? '이름 없음';
        });
      } else {
        setState(() {
          _defaultImage = AssetImage('assets/default_profile.png');
          _userName = '이름 없음';
        });
      }
    });

    // 데이터 로드 호출
    myPageController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double barWidth = screenWidth / 3; // 3개의 탭 중 선택된 탭의 위치에 맞게 조정
    double barPosition = barWidth * tabController.selectedIndex;
    int adjustedIndex = tabController.selectedIndex % 3;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: SizedBox.shrink(),
        leadingWidth: 0,
        title: const Text('마이페이지'),
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
                          image: _defaultImage != null
                              ? DecorationImage(
                                  image: _defaultImage!,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _defaultImage == null
                            ? Center(
                                child: Icon(Icons.person,
                                    size: 50, color: Colors.grey),
                              )
                            : null,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName ?? '이름 없음',
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
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Obx(
                () {
                  List<Map<String, dynamic>> currentTabData;
                  if (adjustedIndex == 0) {
                    currentTabData = myPageController.reviews; // 내 리뷰
                  } else if (adjustedIndex == 1) {
                    currentTabData = myPageController.communities; // 내 운동
                  } else {
                    currentTabData = myPageController.scraps; // 스크랩
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                    ),
                    itemCount: currentTabData.length,
                    itemBuilder: (context, index) {
                      final imageUrl = currentTabData[index]['imageUrl'] ?? '';
                      final reviewId = currentTabData[index]['reviewId'];
                      final communityId =
                          currentTabData[index]['communityId']; // 커뮤니티 ID

                      return GestureDetector(
                        onTap: () {
                          if (adjustedIndex == 1) {
                            _showOptionsMenu(context, communityId);
                          } else {
                            if (reviewId != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReviewShow(reviewId: reviewId),
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: imageUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: Colors.grey[200], // 이미지가 없을 경우 배경색
                          ),
                          child: imageUrl.isEmpty
                              ? Center(child: Icon(Icons.image_not_supported))
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tabWidth = screenWidth / 3;

    return GestureDetector(
      onTap: () {
        setState(() {
          tabController.setSelectedIndex(index);
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
              fontWeight: tabController.selectedIndex == index
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, int communityId) {
    final UserController userController = Get.find();
    final CommunityController communityController = Get.find();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.red, // 빨간색
                ),
                title: Text('삭제하기'),
                onTap: () async {
                  print('Community ID: $communityId'); // 콘솔에 커뮤니티 ID 출력

                  final memberId =
                      int.parse(userController.userId.value); // 현재 사용자 ID 가져오기

                  try {
                    await communityController.deleteCommunity(
                      communityId: communityId,
                      memberId: memberId,
                    );
                    // 커뮤니티 삭제 후 화면 업데이트 또는 피드백 제공
                  } catch (e) {
                    print('Error deleting community: $e');
                  }

                  Navigator.pop(context);
                },
              ),
              // 다른 옵션을 추가할 수 있습니다.
            ],
          ),
        );
      },
    );
  }

  void _showProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return MyPageModal(
          profileImageUrl: _defaultImage is NetworkImage
              ? (_defaultImage as NetworkImage).url
              : null,
          selectedImage: _selectedImage,
          onImageChanged: (image) {
            setState(() {
              _selectedImage = image;
            });
          },
          userName: _userName ?? '', // 기본값을 빈 문자열로 설정
          onUserNameChanged: (name) {
            setState(() {
              _userName = name;
            });
          },
          reviews: myPageController.reviews, // 리뷰 리스트 전달
        );
      },
    );
  }
}
