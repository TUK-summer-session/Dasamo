import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int _selectedIndex = 0; // 현재 선택된 인덱스

  // 각 탭에 따라 보여줄 이미지를 설정합니다.
  final List<List<String>> _tabImages = [
    [
      'assets/images/salad.jpg',
      'assets/images/salad.jpg',
      'assets/images/salad.jpg'
    ],
    [
      'assets/images/profile.jpg',
      'assets/images/profile.jpg',
      'assets/images/profile.jpg'
    ],
    [
      'assets/images/product.jpg',
      'assets/images/product.jpg',
      'assets/images/product.jpg'
    ],
  ];

  @override
  Widget build(BuildContext context) {
    // 화면의 너비를 가져옵니다.
    double screenWidth = MediaQuery.of(context).size.width;

    // 바의 위치를 텍스트 항목에 맞게 조정합니다.
    double barWidth = screenWidth / 3; // 텍스트 항목의 개수에 따라 바의 너비 설정
    double barPosition = screenWidth / 3 * _selectedIndex;

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
      body: Column(
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

          // 추가 이미지나 콘텐츠
          Expanded(
            child: GridView.builder(
              // padding: EdgeInsets.all(20),
              shrinkWrap: true, // GridView의 크기를 부모에 맞게 조정합니다.
              physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3개의 열
                //crossAxisSpacing: 10, // 열 간 간격
                //mainAxisSpacing: 10, // 행 간 간격
                childAspectRatio: 1, // 정사각형 모양
              ),
              itemCount: _tabImages[_selectedIndex].length, // 선택된 탭에 맞는 이미지 개수
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_tabImages[_selectedIndex]
                          [index]), // 현재 선택된 탭에 따라 이미지 설정
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tabWidth = screenWidth / 3;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
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
              fontSize: 25,
              fontWeight:
                  _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
