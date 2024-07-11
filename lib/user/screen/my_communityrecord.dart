import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaist_summer_camp_second_week/auth/provider/auth_provider.dart';
import 'package:kaist_summer_camp_second_week/community/component/board.dart';
import 'package:kaist_summer_camp_second_week/community/model/post_model.dart';
import 'package:kaist_summer_camp_second_week/user/provider/my_comment_provider.dart';

import '../provider/my_post_provider.dart';

class MyCommunityRecordPage extends ConsumerStatefulWidget {
  const MyCommunityRecordPage({super.key});

  @override
  _MyCommunityRecordPageState createState() => _MyCommunityRecordPageState();
}

class _MyCommunityRecordPageState extends ConsumerState<MyCommunityRecordPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final myPosts = ref.watch(myPostProvider);
    final myComments = ref.watch(myCommentProvider);

    if(myPosts.isEmpty) {
      ref.read(myPostProvider.notifier).getPosts();
    }
    if(myComments.isEmpty){
      ref.read(myCommentProvider.notifier).getPosts();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '커뮤니티 작성글/댓글',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '작성 글'),
            Tab(text: '작성 댓글'),
          ],
          labelColor: Colors.black,
          indicatorColor: Colors.green,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostList(myPosts),
          _buildCommentList(myComments),
        ],
      ),
    );
  }

  Widget _buildPostList(List<PostModel> posts) {
    if(posts.isEmpty) {
      return const Center(
        child: Text('작성한 글이 없습니다.'),
      );
    }

    return RefreshIndicator(
      onRefresh: (){
        ref.read(myPostProvider.notifier).getPosts();
        return Future.value();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return GestureDetector(
            onTap: () {
              // 카드 클릭 시 동작 추가
              print('Post Card $index clicked');
              context.go('/postDetail/${posts[index].id}');
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Board.values[post.boardId].name, style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8.0),
                    Text(post.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Text(
                     post.content,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up_alt_outlined),
                          onPressed: () {
                            // 좋아요 버튼 클릭 시 동작 추가
                          },
                        ),
                        Text(post.likesUid.length.toString()),
                        IconButton(
                          icon: const Icon(Icons.comment_outlined),
                          onPressed: () {
                            // 댓글 버튼 클릭 시 동작 추가
                          },
                        ),
                        Text(post.comments.length.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentList(List<PostModel> posts) {
    if(posts.isEmpty) {
      return const Center(
        child: Text('작성한 댓글이 없습니다.'),
      );
    }

    return RefreshIndicator(
      onRefresh: (){
        ref.read(myCommentProvider.notifier).getPosts();
        return Future.value();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return GestureDetector(
            onTap: () {
              // 카드 클릭 시 동작 추가
              print('Post Card $index clicked');
              context.go('/postDetail/${posts[index].id}');
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Board.values[post.boardId].name, style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8.0),
                    Text(post.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Text(
                      post.content,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up_alt_outlined),
                          onPressed: () {
                            // 좋아요 버튼 클릭 시 동작 추가
                          },
                        ),
                        Text(post.likesUid.length.toString()),
                        IconButton(
                          icon: const Icon(Icons.comment_outlined),
                          onPressed: () {
                            // 댓글 버튼 클릭 시 동작 추가
                          },
                        ),
                        Text(post.comments.length.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
