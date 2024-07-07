import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kaist_summer_camp_second_week/community/screen/community.dart';
import 'package:kaist_summer_camp_second_week/community/screen/community_write.dart';
import 'package:kaist_summer_camp_second_week/login_screen.dart';
import 'package:kaist_summer_camp_second_week/user/screen/my_accountsetting.dart';
import 'package:kaist_summer_camp_second_week/user/screen/my_communityrecord.dart';
import 'package:kaist_summer_camp_second_week/auth/screen/my_login.dart';
import 'package:kaist_summer_camp_second_week/user/screen/my_pageafterlogin.dart';
import 'package:kaist_summer_camp_second_week/auth/screen/my_pagebeforelogin.dart';
import 'package:kaist_summer_camp_second_week/user/screen/my_privateinfosetting.dart';
import 'package:kaist_summer_camp_second_week/auth/screen/my_signup.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search_detail.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search_result.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: dotenv.env['kakao_NativeAppKey']!,
  );

  FlutterNaverLogin.initSdk(
      clientId: dotenv.env['naver_ClientID']!,
      clientName: dotenv.env['naver_ClientName']!,
      clientSecret: dotenv.env['naver_ClientSecret']!
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NongDam',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SearchResultPage(), //여기 수정해서 페이지 잘 되었나 보기
    );
  }
}