// 홈 페이지 위젯
import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '커뮤니티 페이지',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 버튼 클릭 시 동작 추가
            },
            child: const Text('버튼'),
          ),
        ],
      ),
    );
  }
}
