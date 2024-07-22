import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../home.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  OAuthToken? _token;

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
                signWithKakao();
                //Get.to(() => const Home());
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

  Future<void> signWithKakao() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    OAuthToken token;

    if (await isKakaoTalkInstalled()) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
        _getUserInfo();
        navigateToHome();
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
          _getUserInfo();
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        _getUserInfo();
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  void navigateToHome() {
    Get.to(() => const Home());
  }

// 빠른 테스트를 위해서 로그인 생략하고 싶으면 User에서 _send 부분 주석처리
  Future<void> _getUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');
      _sendUserInfoToServer(user);
      navigateToHome();
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  Future<void> _sendUserInfoToServer(User user) async {
    final url = Uri.parse(
        'http://localhost:3000/api/members/login'); // 서버 URL을 실제 값으로 대체
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': user.id,
        'nickname': user.kakaoAccount?.profile?.nickname,
        'email': user.kakaoAccount?.email,
        'profileImageUrl': user.kakaoAccount?.profile?.profileImageUrl,
      }),
    );

    if (response.statusCode == 200) {
      print('서버로 사용자 정보 전송 성공');
    } else {
      print('서버로 사용자 정보 전송 실패: ${response.body}');
    }
  }
}
