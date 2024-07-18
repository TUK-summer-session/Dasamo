// 홈 페이지 위젯
import 'package:flutter/material.dart';

// 리뷰 세부페이지
class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // 세로방향 왼쪽
        crossAxisAlignment: CrossAxisAlignment.start, // 가로방향 왼쪽
        children: <Widget>[
          Icon(Icons.chevron_left),
          // 프로필
          Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // 첫 번째와 마지막을 양쪽 끝에 정렬
              children: <Widget>[
                Row(children: <Widget>[
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
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
                  padding: EdgeInsets.only(left: 10), // 왼쪽 여백 추가
                  child: Row(
                    children: [
                      Text('작성자'),
                      Text('게시일'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 리뷰 이미지
          Container(height: 200, width: double.infinity, color: Colors.grey),

          // 하트, 댓글 등
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 10, 20, 10),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // 첫 번째와 마지막을 양쪽 끝에 정렬
              children: <Widget>[
                Row(children: <Widget>[
                  Icon(Icons.favorite_border),
                  SizedBox(width: 5),
                  Icon(Icons.chat_bubble_outline),
                  SizedBox(width: 5),
                  Icon(Icons.bookmark_border)
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
                            color: Colors.black, // 테두리 색상
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
                            color: Colors.black, // 테두리 색상
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
                  color: Colors.black, // 위쪽 테두리 색상
                  width: 1.0, // 위쪽 테두리 두께
                ),
                bottom: BorderSide(
                  color: Colors.black, // 아래쪽 테두리 색상
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
                      color: Colors.grey,
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
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(175, 99, 120, 0.43),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            '구매하기',
                            style: TextStyle(
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

          Container(
            padding: EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '이거 진짜 맛있어요',
                style: TextStyle(
                  fontSize: 18, // 글자 크기
                  // 글자 색상
                ),
              ),
              SizedBox(height: 20),
              Text(
                '샬라샬라샤랄랴살샤ㅏㄹㄹ샤ㅏㄹ샬샬라',
                style: TextStyle(
                  fontSize: 15, // 글자 크기
                  // 글자 색상
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
