// 홈 페이지 위젯
import 'package:dasamo/src/widgets/Input/comment_input.dart';
import 'package:dasamo/src/widgets/Input/comments.dart';
import 'package:dasamo/src/widgets/expand/expand_text.dart';
import 'package:dasamo/src/widgets/list/star_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// 리뷰 세부페이지
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  // 아이콘 hover
  bool _favoriteHovered = false;
  bool _favoriteTapped = false;

  bool _commentHovered = false;
  bool _commentTapped = false;

  bool _bookmarkHovered = false;
  bool _bookmarkTapped = false;

  // 구매하기 버튼 hover
  bool _buttonHovered = false;

  // 텍스트 확장
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // 세로방향 왼쪽
        crossAxisAlignment: CrossAxisAlignment.start, // 가로방향 왼쪽
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0), // 원하는 패딩 값 설정
            child: Text('커뮤니티'),
          ),
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
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
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
                      print('Bookmark 아이콘을 탭했습니다.');
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
                ]),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ExpandText(
                text:
                    '샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라',
                style: TextStyle(
                  fontSize: 15, // 글자 크기
                ),
              ),
              SizedBox(height: 10),
            ]),
          ),
        ],
      ),
    );
  }
}
