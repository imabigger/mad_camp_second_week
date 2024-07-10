
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaist_summer_camp_second_week/community/model/post_model.dart';
import 'package:kaist_summer_camp_second_week/component/dio/provider/dio_provider.dart';
import 'package:dio/dio.dart';

final queryPostProvider = StateNotifierProvider<QueryPostNotifier, List<PostModel>>((ref) {
  return QueryPostNotifier(ref: ref);
});

class QueryPostNotifier extends StateNotifier<List<PostModel>>{
  Ref ref;
  int _currentPage = 0;
  final int _limit = 20;
  bool _hasMore = true;

  QueryPostNotifier({required this.ref}) : super([]);

  Future<void> getPostsWithQuery({bool isRefresh = false,required String query}) async {
    if (isRefresh) {
      _currentPage = 0;
      _hasMore = true;
      state = [];
    }

    if (!_hasMore) {
      return;
    }

    try {
      final dio = ref.read(dioProvider);

      final response = await dio.get('/posts/', queryParameters: {
        'limit': _limit,
        'page': _currentPage,
        'query' : query,
      });

      final responseJson = response.data;
      final posts = (responseJson as List).map((post) => PostModel.fromJson(post)).toList();


      if (posts.length < _limit) {
        _hasMore = false;
      }

      state = [...state, ...posts];
      _currentPage++;
    } catch (e) {
      print('Get posts failed: $e');
      throw Exception();
    }
  }

  Future<void> queryStart() async {
    state = [];
    _hasMore = true;
    _currentPage = 0;
  }

  Future<void> increaseViewCountPut({required String postId}) async{
    try {
      final dio = ref.read(dioProvider);
      await dio.put('/posts/$postId/increment-views');

      return;
    } catch (e) {
      print('[Increase view count failed]: $e');
      throw Exception();
    }
  }
}