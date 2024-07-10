import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaist_summer_camp_second_week/auth/provider/auth_provider.dart';
import 'package:kaist_summer_camp_second_week/community/model/post_model.dart';
import 'package:kaist_summer_camp_second_week/community/provider/post_provider.dart';
import 'package:kaist_summer_camp_second_week/community/provider/query_post_provider.dart';
import 'package:kaist_summer_camp_second_week/search/model/plant_model.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search_detail.dart';

import '../component/board.dart';

class CommunitySearchPage extends ConsumerStatefulWidget {
  const CommunitySearchPage({super.key});

  @override
  _CommunitySearchPageState createState() => _CommunitySearchPageState();
}

class _CommunitySearchPageState extends ConsumerState<CommunitySearchPage> {
  final TextEditingController _searchTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(_filterPosts);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchTextController.removeListener(_filterPosts);
    _searchTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterPosts() {
    if(_searchTextController.text.isEmpty) {
      return;
    }
    final query = _searchTextController.text.toLowerCase();
    ref.read(queryPostProvider.notifier).getPostsWithQuery(query: query, isRefresh: true);
  }

  void _onScroll() {
    final query = _searchTextController.text.toLowerCase();
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(queryPostProvider.notifier).getPostsWithQuery(query: query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final queryPost = ref.watch(queryPostProvider);

    return GestureDetector(
      onPanDown: (_){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0), // AppBar 높이 조정
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // 화살표 버튼 클릭 시 동작 추가
              },
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _searchTextController,
                decoration: InputDecoration(
                  hintText: '궁금한 글의 제목을 입력하세요',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // 더 둥근 모서리
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: queryPost.isEmpty
                    ? Center(child: Text('게시글이 없습니다.'))
                    : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: queryPost.length,
                  itemBuilder: (context, index) {
                    final post = queryPost[index];

                    return InkWell(
                      onTap: () {
                        ref.read(postProvider.notifier).increaseViewCountPut(postId: post.id);
                        context.go('/queryPost/${post.id}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Board.values[post.boardId].name,
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 8.0),
                            Text(
                              post.title,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.content,
                                        maxLines: 3,
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            const Divider(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}