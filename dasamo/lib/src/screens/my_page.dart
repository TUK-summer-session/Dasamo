import 'package:dasamo/src/controllers/my_page_tab_controller.dart';
import 'package:dasamo/src/shared/tab_data.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final MyPageTabController controller = MyPageTabController();

  @override
  Widget build(BuildContext context) {
    // 화면의 너비를 가져옵니다.
    double screenWidth = MediaQuery.of(context).size.width;

    // 바의 위치를 텍스트 항목에 맞게 조정합니다.
    double barWidth =
        screenWidth / tabDataList.length; // 텍스트 항목의 개수에 따라 바의 너비 설정
    double barPosition = barWidth * controller.selectedIndex;

    // 현재 선택된 탭의 데이터
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
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    Container(
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
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '작성자',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            ),

            // 텍스트 및 바
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Stack(
                children: [
                  // 바
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

                  // 텍스트
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
              shrinkWrap: true, // GridView의 크기를 부모에 맞게 조정합니다.
              physics: NeverScrollableScrollPhysics(), // GridView 자체의 스크롤 비활성화
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3개의 열
                childAspectRatio: 1, // 정사각형 모양
              ),
              itemCount: currentTabData.images.length, // 선택된 탭에 맞는 이미지 개수
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          currentTabData.images[index]), // 현재 선택된 탭에 따라 이미지 설정
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
          height: 50, // 탭의 높이 설정
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
}
