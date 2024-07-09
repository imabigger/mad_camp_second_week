import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaist_summer_camp_second_week/auth/provider/auth_provider.dart';
import 'package:kaist_summer_camp_second_week/community/model/post_model.dart';
import 'package:kaist_summer_camp_second_week/community/provider/post_provider.dart';
import 'package:kaist_summer_camp_second_week/search/model/plant_model.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search_detail.dart';

import '../component/board.dart';

class CommunitySearchPage extends ConsumerStatefulWidget {
  const CommunitySearchPage({super.key});

  @override
  _CommunitySearchPageState createState() => _CommunitySearchPageState();
}

class _CommunitySearchPageState extends ConsumerState<CommunitySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<PostModel> emptyPosts = [];
  List<PostModel> filteredPosts = [];


  @override
  void initState() {
    super.initState();
    filteredPosts = emptyPosts;
    _searchController.addListener(_filterPosts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPosts);
    _searchController.dispose();
    super.dispose();
  }

  void _filterPosts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      List<PostModel> allPosts = ref.watch(postProvider);
      filteredPosts = allPosts.where((PostModel) {
        return PostModel.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
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
              controller: _searchController,
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
            const SizedBox(height: 10),

            Expanded(
              child: filteredPosts.isEmpty
                  ? Center(child: Text('게시글이 없습니다.'))
                  : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: filteredPosts.length,
                itemBuilder: (context, index) {
                  final post = filteredPosts[index];

                  return Padding(
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
                                    post.title,
                                    maxLines: 3,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image,  ///  이미지를 넣어야함.
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: post.likesUid.contains(user?.id) ? Icon(Icons.favorite,
                                    color: Colors.red) : Icon(Icons.favorite_border,
                                    color: Colors.red),
                                onPressed: () async {
                                  // 좋아요 버튼 클릭 시 동작 추가
                                  if(user == null) {
                                    context.go('/auth');

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('로그인이 필요한 서비스입니다.'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                    return;
                                  }

                                  if(post.likesUid.contains(user.id)) {
                                    await ref.read(postProvider.notifier).unlikePost(postId: post.id, uid: user.id);
                                  } else {
                                    await ref.read(postProvider.notifier)
                                        .likePost(
                                        postId: post.id, uid: user.id);
                                  }
                                  setState(() {

                                  });
                                },
                              ),

                              Text(post.likesUid.length.toString()),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.comment_outlined,
                                    color: Colors.black),
                                onPressed: () {
                                  // 댓글 버튼 클릭 시 동작 추가
                                },
                              ),
                              Text(post.comments.length.toString()),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}