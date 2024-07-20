import 'package:flutter/material.dart';

class MyPageTabController {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
  }
}
