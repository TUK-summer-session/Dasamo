import 'package:dasamo/src/home.dart';
import 'package:dasamo/src/screens/community_page.dart';
import 'package:dasamo/src/screens/intro.dart';
import 'package:dasamo/src/screens/my_page.dart';
import 'package:dasamo/src/screens/review/show.dart';
import 'package:dasamo/src/shared/review/goods_data.dart';
import 'package:dasamo/src/shared/review/review_data.dart';
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
              fontFamily: 'Nanum',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            foregroundColor: Colors.black,
            minimumSize: const Size(360, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color.fromRGBO(175, 99, 120, 1),
        ),
        // inputDecorationTheme: InputDecorationTheme(
        //   border: UnderlineInputBorder(
        //     borderSide: BorderSide(color: Colors.grey), // 기본 테두리 색상
        //   ),
        //   focusedBorder: UnderlineInputBorder(
        //     borderSide: BorderSide(color: Color(0xFFAF6378)), // 포커스된 상태의 색상
        //   ),
        //   enabledBorder: UnderlineInputBorder(
        //     borderSide: BorderSide(color: Colors.grey), // 비활성 상태의 색상
        //   ),
        //   hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상
        // ),
      ),
      routes: {
        '/': (context) => Intro(),
        '/community': (context) => CommunityPage(),
        '/mypage': (context) => MyPage(),
      },
      initialRoute: '/',
      onGenerateRoute: (route) {
        if (route.name!.startsWith('/review/')) {
          final id = int.parse(route.name!.split('/').last);
          final reviewItem = reviewData.firstWhere((e) => e['id'] == id);

          return MaterialPageRoute(
            builder: (context) => ReviewShow(reviewItem: reviewItem),
          );
        }
        return null;
      },
    );
  }
}
