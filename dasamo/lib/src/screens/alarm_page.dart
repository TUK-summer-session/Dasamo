import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  // 상태 클래스의 멤버로 리스트를 정의
  List<String> usernames = ['Alice', 'Bob', 'Charlie', 'David', 'Eve'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 리스트의 각 항목을 Row로 표시
            ...usernames.map((username) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$username님이 좋아요를 눌렀습니다.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () {
                        // 삭제 기능 구현
                        setState(() {
                          usernames.remove(username);
                        });
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
