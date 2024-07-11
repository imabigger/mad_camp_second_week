
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaist_summer_camp_second_week/auth/provider/auth_provider.dart';
import 'package:kaist_summer_camp_second_week/community/model/post_model.dart';
import 'package:kaist_summer_camp_second_week/component/dio/provider/dio_provider.dart';
import 'package:dio/dio.dart';

final myPostProvider = StateNotifierProvider<MyPostNotifier, List<PostModel>>((ref) {
  return MyPostNotifier(ref: ref);
});

class MyPostNotifier extends StateNotifier<List<PostModel>>{
  Ref ref;

  MyPostNotifier({required this.ref}) : super([]);

  Future<void> getPosts({bool isRefresh = false}) async {
    final user = ref.read(authProvider).user;

    if (isRefresh || user == null) {
      state = [];
    }

    try {
      final dio = ref.read(dioProvider);

      final response = await dio.get('/posts/my-posts/${user!.id}');

      final responseJson = response.data;
      final posts = (responseJson as List).map((post) => PostModel.fromJson(post)).toList();

      state = [...posts];
    } catch (e) {
      print('Get posts failed: $e');
      throw Exception();
    }
  }

}