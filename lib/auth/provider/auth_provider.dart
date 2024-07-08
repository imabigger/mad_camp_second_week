import 'dart:convert';

import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaist_summer_camp_second_week/auth/auth.dart';
import 'package:kaist_summer_camp_second_week/component/dio/provider/dio_provider.dart';
import 'package:kaist_summer_camp_second_week/user/model/user_model.dart' as user_model;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._ref) : super(AuthState(isLoggedIn: false, user: null, accessToken: null, refreshToken: null));

  final Ref _ref;

  Future<bool> logInWithEmail({required String email,required String password}) async {
    try {
      final dio = _ref.read(dioProvider);
      final response = await dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      final responseJson = response.data['user'];
      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];

      final user = user_model.User.fromJson(responseJson);

      state = state.copyWith(isLoggedIn: true, user: user, accessToken: accessToken, refreshToken: refreshToken);
      return true;
    } catch (e) {
      print('Login failed: $e');
      throw Exception();
    }
  }

  Future<bool> logInWithKaKao() async {
    try {
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      var me = await UserApi.instance.me();

      if(me.kakaoAccount == null) {
        print('No Kakao account found');
        throw Exception('No Kakao account found');
      }

      final dio = _ref.read(dioProvider);
      final response = await dio.post('/auth/kakao', data: {
        'id': me.id,
        'nickname': me.kakaoAccount!.profile!.nickname,
        'email': me.kakaoAccount!.email,
      });

      final responseJson = response.data['user'];
      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];

      final user = user_model.User.fromJson(responseJson);

      state = state.copyWith(isLoggedIn: true, user: user, accessToken: accessToken, refreshToken: refreshToken);
      return true;
    } catch (e) {
      print('Login failed: $e');
      throw Exception();
    }
  }

  Future<bool> logInWithNaver() async {
    try {
      final NaverLoginResult res = await FlutterNaverLogin.logIn();

      if(res.status != NaverLoginStatus.loggedIn) {
        throw Exception('No Naver account found');
      }

      final dio = _ref.read(dioProvider);
      final response = await dio.post('/auth/naver', data: {
        'id': res.account.id,
        'nickname': res.account.name,
        'email': res.account.email,
      });

      final responseJson = response.data['user'];
      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];

      final user = user_model.User.fromJson(responseJson);

      state = state.copyWith(isLoggedIn: true, user: user, accessToken: accessToken, refreshToken: refreshToken);
      return true;
    } catch (e) {
      print('Login failed: $e');
      throw Exception();
    }
  }

  Future<void> refreshToken() async {
    try {
      final dio = _ref.read(dioProvider);
      final response = await dio.post('/token', data: {
        'refreshToken': state.refreshToken,
      });

      final accessToken = response.data['token'];
      final refreshToken = response.data['refreshToken'];

      state = state.copyWith(isLoggedIn: true, accessToken: accessToken, refreshToken: refreshToken);
    } catch (e) {
      print('Login failed: $e');
      print('...Refresh token failed');
      print("Log out...");
      logOut();

      throw Exception();
    }
  }

  void logOut() {
    state = state.copyWith(isLoggedIn: false, user: null, accessToken: null, refreshToken: null);
  }
}