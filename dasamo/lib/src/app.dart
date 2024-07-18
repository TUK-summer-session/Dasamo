import 'package:dasamo/src/home.dart';
import 'package:dasamo/src/screens/community_page.dart';
import 'package:dasamo/src/screens/home_page.dart';
import 'package:dasamo/src/screens/intro.dart';
import 'package:dasamo/src/screens/my_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Nanum',
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(175, 99, 120, 1),
            padding: const EdgeInsets.symmetric(vertical: 12),
            textStyle: TextStyle(
                fontFamily: 'Nanum', fontWeight: FontWeight.bold, fontSize: 24),
            foregroundColor: Colors.black,
            minimumSize: const Size(300, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ))),
      routes: {
        '/': (context) => Intro(),
        '/home': (context) => HomePage(),
        '/community': (context) => CommunityPage(),
        '/mypage': (context) => MyPage(),
      },
      initialRoute: '/',
    );
  }
}
