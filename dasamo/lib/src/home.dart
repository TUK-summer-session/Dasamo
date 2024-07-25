import 'package:dasamo/src/screens/review/index.dart';
import 'package:flutter/material.dart';
import 'package:dasamo/src/screens/community_page.dart';
import 'package:dasamo/src/screens/my_page.dart';

class Home extends StatefulWidget {
  final int initialIndex;

  const Home({super.key, this.initialIndex = 0});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // 초기 탭 인덱스를 설정
  }

  final List<BottomNavigationBarItem> myTabs = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: '홈',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.feed),
      label: '커뮤',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: '마이',
    ),
  ];

  final List<Widget> myTabItems = [
    ReviewIndex(),
    CommunityPage(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: myTabs,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: myTabItems,
      ),
    );
  }
}
