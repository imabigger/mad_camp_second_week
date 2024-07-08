import 'package:kaist_summer_camp_second_week/user/model/user_model.dart';

class AuthState {
  final bool isLoggedIn;
  final User? user;
  final String? accessToken;
  final String? refreshToken;
  final bool isKakaoTalkLogin;
  final bool isNaverLogin;

  AuthState({
    required this.isLoggedIn,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.isKakaoTalkLogin = false,
    this.isNaverLogin = false,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    User? user,
    String? accessToken,
    String? refreshToken,
    bool? isKakaoTalkLogin,
    bool? isNaverLogin,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      isKakaoTalkLogin: isKakaoTalkLogin ?? this.isKakaoTalkLogin,
      isNaverLogin: isNaverLogin ?? this.isNaverLogin,
    );
  }
}