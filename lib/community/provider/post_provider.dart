
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaist_summer_camp_second_week/community/model/post_model.dart';
import 'package:kaist_summer_camp_second_week/component/dio/provider/dio_provider.dart';
import 'package:dio/dio.dart';

final postProvider = StateNotifierProvider<PostNotifier, List<PostModel>>((ref) {
  return PostNotifier(ref: ref);
});

class PostNotifier extends StateNotifier<List<PostModel>>{
  StateNotifierProviderRef ref;
  int _currentPage = 0;
  final int _limit = 20;
  bool _hasMore = true;

  PostNotifier({required this.ref}) : super([]);

  Future<void> getPosts({bool isRefresh = false}) async {
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


  Future<void> likePost({required String postId, required String uid}) async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.post('/posts/$postId/like');

      final postIndex = state.indexWhere((post) => post.id == postId);
      final post = state[postIndex];
      state[postIndex] = post.copyWith(likesUid: [...post.likesUid, uid]);
    } catch (e) {
      print('[Like post failed]: $e');
      throw Exception();
    }
  }

  Future<void> unlikePost({required String postId, required String uid}) async {
    print(postId);
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.delete('/posts/$postId/unlike');

      final postIndex = state.indexWhere((post) => post.id == postId);
      final post = state[postIndex];
      state[postIndex] = post.copyWith(likesUid: post.likesUid.where((likeUid) => likeUid != uid).toList());
    } catch (e) {
      print('[Unlike post failed]: $e');
      throw Exception();
    }
  }
}