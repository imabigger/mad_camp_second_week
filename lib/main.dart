import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'route/go_route.dart';

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
      clientSecret: dotenv.env['naver_ClientSecret']!);

  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NongDam',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routerConfig: router,
    );
  }
}
