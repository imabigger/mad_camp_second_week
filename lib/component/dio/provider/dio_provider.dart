import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:kaist_summer_camp_second_week/auth/provider/auth_provider.dart';
import 'dart:io';

// DioProvider 정의
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://172.10.7.138',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
    ),
  );

  dio.options.headers['Content-Type'] = 'application/json';

  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };

  // Interceptor 설정
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      // AuthProvider의 상태를 읽어 토큰을 헤더에 추가
      final authState = ref.read(authProvider);
      final token = authState.accessToken;

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      print('[Request]: ${options.method} ${options.uri}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      // 응답을 받은 후 처리
      print('[Response]: ${response.statusCode} ${response.data}');
      return handler.next(response);
    },
    onError: (e, handler) async {
      // 에러가 발생했을 때 처리
      if (e.response?.statusCode == 401 && e.response?.data['message'] != 'Refresh Token Expired') {
        // 토큰 만료 시 재발급
        print('[Response]: 401 Unauthorized => Refresh Token');
        try {
          await ref.read(authProvider.notifier).refreshToken();
        } catch (refreshError) {
          print('Token refresh failed: $refreshError');
        }
      }

      print('[Error]: ${e.response?.statusCode} ${e.message}');
      return handler.next(e);
    },
  ));

  return dio;
});
