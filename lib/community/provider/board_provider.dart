
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaist_summer_camp_second_week/community/component/board.dart';
import 'package:kaist_summer_camp_second_week/community/model/post_model.dart';
import 'package:kaist_summer_camp_second_week/component/dio/provider/dio_provider.dart';
import 'package:dio/dio.dart';

final boardPostProvider = StateNotifierProviderFamily<BoardPostNotifier, List<PostModel>, Board>((ref, board) {
  return BoardPostNotifier(ref: ref, board: board);
});

class BoardPostNotifier extends StateNotifier<List<PostModel>>{
  Ref ref;
  Board board;

  BoardPostNotifier({required this.ref, required this.board}) : super([]){
    getBoardPost(5);
  }

  Future<void> getBoardPost(int count) async {
    final dio = ref.read(dioProvider);

    try {
      final boardId = board.index;
      final response = await dio.get('/posts/board/$boardId', data: {
        'count': count,
      });

      final responseJson = response.data;
      final posts = (responseJson as List).map((post) => PostModel.fromJson(post)).toList();

      state = posts;
    } catch (e) {
      print('Get posts failed: $e');
      throw Exception();
    }

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