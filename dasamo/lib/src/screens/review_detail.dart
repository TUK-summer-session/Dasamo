// 홈 페이지 위젯
import 'package:dasamo/src/widgets/Input/comment_input.dart';
import 'package:dasamo/src/widgets/Input/comments.dart';
import 'package:dasamo/src/widgets/list/star_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// 리뷰 세부페이지
class ReviewDetail extends StatefulWidget {
  const ReviewDetail({super.key});

  @override
  State<ReviewDetail> createState() => _ReviewDetailState();
}

class _ReviewDetailState extends State<ReviewDetail> {
  // 아이콘 hover
  bool _favoriteHovered = false;
  bool _favoriteTapped = false;

  bool _commentHovered = false;
  bool _commentTapped = false;

  bool _bookmarkHovered = false;
  bool _bookmarkTapped = false;

  // 구매하기 버튼 hover
  bool _buttonHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 세로방향 왼쪽
          crossAxisAlignment: CrossAxisAlignment.start, // 가로방향 왼쪽
          children: <Widget>[
            // 프로필
            Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // 첫 번째와 마지막을 양쪽 끝에 정렬
                children: <Widget>[
                  Row(children: <Widget>[
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/profile.jpg'), // 로컬 이미지
                          fit: BoxFit.cover, // 이미지를 컨테이너 크기에 맞춤
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20), // 왼쪽 여백 추가
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('작성자'),
                          SizedBox(height: 5),
                          Text(
                            '게시일',
                            style: TextStyle(
                              fontSize: 10, // 글자 크기
                              color: Colors.grey, // 글자 색상
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10), // 왼쪽 여백 추가
                    child: StarListWidget(number: 3),
                  ),
                ],
              ),
            ),

            // 리뷰 이미지
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/salad.jpg'), // 로컬 이미지
                  fit: BoxFit.cover, // 이미지를 컨테이너 크기에 맞춤
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // 그림자 색상과 투명도
                    spreadRadius: 0.5, // 그림자 크기
                    blurRadius: 3, // 흐림 정도
                    offset: Offset(0, 3), // 그림자 위치 (x, y)
                  ),
                ],
              ),
            ),

            // 하트, 댓글 등
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 20, 20, 20),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // 첫 번째와 마지막을 양쪽 끝에 정렬
                children: <Widget>[
                  Row(children: <Widget>[
                    InkWell(
                      onHover: (hovered) {
                        setState(() {
                          _favoriteHovered = hovered; // 마우스 호버 상태 업데이트
                        });
                      },
                      onTap: () {
                        setState(() {
                          _favoriteTapped = !_favoriteTapped; // 아이콘의 탭 상태 토글
                        });
                        print('하트 아이콘을 탭했습니다.');
                      },
                      child: _favoriteTapped
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red, // 클릭된 경우 색상
                            )
                          : Icon(
                              _favoriteHovered
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _favoriteHovered ? Colors.red : null,
                            ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onHover: (hovered) {
                        setState(() {
                          _commentHovered = hovered;
                        });
                      },
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true, // 모달 높이 조절
                          builder: (context) {
                            double screenHeight =
                                MediaQuery.of(context).size.height;
                            return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: screenHeight * 0.7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              child: Container(
                                                // 내부 컨테이너 예시
                                                height: 5,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                            ), // 간격을 주기 위한 Container
                                            Comments(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: CommentInput(
                                        onSave: (comment) {
                                          // 저장 로직을 이곳에 구현
                                          print('저장된 댓글: $comment');
                                          // 저장 처리 로직 추가 가능
                                        },
                                      ),
                                    ),
                                  ],
                                ));
                          },
                        );
                        print('Comment 아이콘을 탭했습니다.');
                      },
                      child: Icon(
                        _commentHovered
                            ? Icons.chat_bubble
                            : Icons.chat_bubble_outline,
                        color: _commentHovered
                            ? Color.fromRGBO(175, 99, 120, 1.0)
                            : null,
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onHover: (hovered) {
                        setState(() {
                          _bookmarkHovered = hovered; // 마우스 호버 상태 업데이트
                        });
                      },
                      onTap: () {
                        setState(() {
                          _bookmarkTapped = !_bookmarkTapped; // 아이콘의 탭 상태 토글
                        });
                        print('Bookmark 아이콘을 탭했습니다.');
                      },
                      child: _bookmarkTapped
                          ? Icon(
                              Icons.bookmark,
                              color: Color.fromRGBO(
                                  255, 193, 100, 1.0), // 클릭된 경우 색상
                            )
                          : Icon(
                              _bookmarkHovered
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: _bookmarkHovered
                                  ? Color.fromRGBO(255, 193, 100, 1.0)
                                  : null,
                            ),
                    ),
                  ]),
                  Container(
                    padding: EdgeInsets.only(left: 10), // 왼쪽 여백 추가
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                          height: 20,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  Color.fromARGB(255, 113, 113, 113), // 테두리 색상
                              width: 1.0, // 테두리 두께
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '비건',
                              style: TextStyle(
                                // 텍스트 색상
                                fontSize: 12, // 텍스트 크기
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                          height: 20,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  Color.fromARGB(255, 113, 113, 113), // 테두리 색상
                              width: 1.0, // 테두리 두께
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '비건',
                              style: TextStyle(
                                // 텍스트 색상
                                fontSize: 12, // 텍스트 크기
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 구매하기
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(255, 163, 163, 163), // 위쪽 테두리 색상
                    width: 1.0, // 위쪽 테두리 두께
                  ),
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 163, 163, 163), // 아래쪽 테두리 색상
                    width: 1.0, // 아래쪽 테두리 두께
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // 첫 번째와 마지막을 양쪽 끝에 정렬
                children: <Widget>[
                  Row(children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/product.jpg'), // 로컬 이미지
                          fit: BoxFit.cover, // 이미지를 컨테이너 크기에 맞춤
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20), // 왼쪽 여백 추가
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('상품명'),
                          SizedBox(height: 5),
                          Text(
                            '가격',
                          ),
                        ],
                      ),
                    ),
                  ]),
                  Container(
                    padding: EdgeInsets.only(left: 10), // 왼쪽 여백 추가
                    child: Row(
                      children: [
                        // 버튼
                        InkWell(
                          onHover: (hovered) {
                            setState(() {
                              _buttonHovered = hovered; // 마우스 호버 상태 업데이트
                            });
                          },
                          onTap: () {
                            // 버튼을 탭했을 때 실행할 동작
                            print('구매하기 버튼을 탭했습니다.');
                          },
                          child: AnimatedContainer(
                            duration:
                                Duration(milliseconds: 100), // 애니메이션 지속 시간 설정
                            decoration: BoxDecoration(
                              color: _buttonHovered
                                  ? Color.fromRGBO(175, 99, 120, 1.0)
                                  : Color.fromRGBO(175, 99, 120, 0.43),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              '구매하기',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이거 진짜 맛있어요',
                      style: TextStyle(
                        fontSize: 18, // 글자 크기
                        // 글자 색상
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라',
                      style: TextStyle(
                        fontSize: 15, // 글자 크기
                        // 글자 색상
                      ),
                    ),
                    SizedBox(height: 10),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
