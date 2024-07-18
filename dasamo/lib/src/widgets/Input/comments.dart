import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  final List<Map<String, dynamic>> comments = [
    {
      'profileImage': 'assets/images/salad.jpg',
      'author': 'User1',
      'content': '이 글 정말 좋네요!',
    },
    {
      'profileImage': 'assets/images/salad.jpg',
      'author': 'User2',
      'content': '감사합니다!',
    },
    {
      'profileImage': 'assets/images/salad.jpg',
      'author': 'User2',
      'content': '감사합니다!',
    },
    {
      'profileImage': 'assets/images/salad.jpg',
      'author': 'User2',
      'content': '감사합니다!',
    },
    {
      'profileImage': 'assets/images/salad.jpg',
      'author': 'User2',
      'content': '감사합니다!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: comments.map((comment) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 20, 30, 0), // 패딩값 설정
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(comment['profileImage']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(comment['author']),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  comment['content'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
