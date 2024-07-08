import 'package:kaist_summer_camp_second_week/user/model/user_model.dart';

class AuthState {
  final bool isLoggedIn;
  final User? user;
  final String? accessToken;
  final String? refreshToken;

  AuthState({
    required this.isLoggedIn,
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    User? user,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}