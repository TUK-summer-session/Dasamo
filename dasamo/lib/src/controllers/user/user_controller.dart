import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  var userId = ''.obs;
  var nickname = ''.obs;
  var email = ''.obs;
  var profileImageUrl = ''.obs;
  var member = Rxn<Map<String, dynamic>>();

  void setUser(String id, String name, String mail, String profileUrl) {
    userId.value = id ?? '';
    nickname.value = name ?? '';
    email.value = mail ?? '';
    profileImageUrl.value = profileUrl ?? '';
  }

  Future<void> signWithKakao() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
        await getUserInfo();
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
          await getUserInfo();
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        await getUserInfo();
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  Future<void> getUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');
      await _sendUserInfoToServer(user);
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  Future<void> _sendUserInfoToServer(User user) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/members/login');
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
      var responseBody = jsonDecode(response.body);
      member.value = responseBody['data']['member'];
      setUser(
          member.value?['memberId'].toString() ?? '',
          member.value?['nickname'] ?? '',
          member.value?['email'] ?? '',
          member.value?['profileImageUrl'] ?? '');

      print('유저 아이디: $userId');
    } else {
      print('서버로 사용자 정보 전송 실패: ${response.body}');
    }
  }
}
