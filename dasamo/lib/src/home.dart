import 'package:dasamo/src/screens/review/index.dart';
import 'package:flutter/material.dart';
import 'package:dasamo/src/screens/community_page.dart';
import 'package:dasamo/src/screens/my_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<BottomNavigationBarItem> myTabs = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: '홈',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.feed),
      label: '동네',
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
