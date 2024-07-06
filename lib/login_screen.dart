import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_naver_login/flutter_naver_login.dart';



class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kakao Login')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  OAuthToken token;
                  if (await isKakaoTalkInstalled()) {
                    token = await UserApi.instance.loginWithKakaoTalk();
                  } else {
                    token = await UserApi.instance.loginWithKakaoAccount();
                  }

                  print('Kakao Login succeeded. Access Token: ${token.accessToken}');

                  var me = await UserApi.instance.me();

                  if(me.kakaoAccount == null) {
                    print('No Kakao account found');
                    throw Exception('No Kakao account found');
                  }

                  var response = await http.post(
                    Uri.parse('http://172.10.7.138/auth/kakao'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({'accessToken': token.accessToken,
                      'id': me.id,
                      'nickname': me.kakaoAccount!.profile!.nickname,
                      'email': me.kakaoAccount!.email,
                    }),
                  );


                  if (response.statusCode == 200) {
                    // 로그인 성공 처리
                    print('Login successful');
                    print(response.body);
                  } else {
                    // 로그인 실패 처리
                    print('Login failed');
                    print(response.body);
                  }
                } catch (e) {
                  print('Error during login: $e');
                }
              },
              child: Text('Login with Kakao'),
            ),

            ElevatedButton(
              onPressed: () async {

                final NaverLoginResult res = await FlutterNaverLogin.logIn();
                if (res.status == NaverLoginStatus.loggedIn) {
                  print('Login successful!');
                  print('Access token: ${res.accessToken}');
                  print('User id: ${res.account.name}');
                  print('Email: ${res.account.email}');
                } else {
                  print('Login failed');
                }
              },
              child: Text('Login with Naver'),
            ),
          ],
        ),
      ),
    );
  }
}
