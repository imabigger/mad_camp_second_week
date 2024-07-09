import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:kaist_summer_camp_second_week/auth/provider/auth_provider.dart';
import 'dart:io';


final dioProvider = StateNotifierProvider<DioNotifier, Dio>((ref) {
  return DioNotifier(ref);
});

class DioNotifier extends StateNotifier<Dio> {
  final StateNotifierProviderRef ref;

  DioNotifier(this.ref) : super(_createDio(ref)) {
    _initializeDio();
  }

  static Dio _createDio(StateNotifierProviderRef ref) {
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

    return dio;
  }

  void _initializeDio() {
    state.interceptors.clear(); // 기존 인터셉터 제거

    // Interceptor 설정
    state.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // AuthProvider의 상태를 읽어 토큰을 헤더에 추가
        final authState = ref.read(authProvider);
        final token = authState.accessToken;
        print('token: $token');

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
            // 재발급된 토큰으로 요청 다시 시도
            final newAuthState = ref.read(authProvider);
            final newToken = newAuthState.accessToken;

            if (newToken != null) {
              e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final clonedRequest = await state.request(
                e.requestOptions.path,
                options: Options(
                  method: e.requestOptions.method,
                  headers: e.requestOptions.headers,
                ),
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
              );
              return handler.resolve(clonedRequest);
            }
          } catch (refreshError) {
            print('[Token refresh failed]: $refreshError');
          }
        }

        print('[Error]: ${e.response?.statusCode} ${e.message}');
        return handler.next(e);
      },
    ));
  }

  void updateDio() {
    // 새 Dio 인스턴스를 생성하고 상태를 업데이트
    state = _createDio(ref);
    _initializeDio(); // 새 인스턴스 초기화
  }
}