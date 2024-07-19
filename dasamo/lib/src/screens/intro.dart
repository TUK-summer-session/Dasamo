import 'package:dasamo/src/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 로고 슬로건 영역
          Expanded(
              child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //로고
                SvgPicture.asset(
                  'assets/images/dasamo_logo.svg',
                  width: 112,
                  height: 54,
                ),
                //슬로건
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  '다이어트를 사랑하는 사람들의 모임',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => const Home());
              },
              child: const Text('카카오로 시작하기'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 193, 100, 1),
                  textStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Nanum',
                      fontSize: 24)),
            ),
          )
        ],
      ),
    );
  }
}
