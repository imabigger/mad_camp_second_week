import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaist_summer_camp_second_week/auth/provider/auth_provider.dart';
import 'package:kaist_summer_camp_second_week/community/component/board.dart';
import 'package:kaist_summer_camp_second_week/community/model/post_model.dart';

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

    if(myPosts.isEmpty) {
      ref.read(myPostProvider.notifier).getPosts();
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
          _buildCommentList(),
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

    return ListView.builder(
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
                      const Text('0'),
                      IconButton(
                        icon: const Icon(Icons.comment_outlined),
                        onPressed: () {
                          // 댓글 버튼 클릭 시 동작 추가
                        },
                      ),
                      const Text('1'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 2,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // 카드 클릭 시 동작 추가
            print('Comment Card $index clicked');
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('묻고 답해요', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8.0),
                  const Text('강낭콩을 심었는데 싹이 올라오지 않아요', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  const Text(
                    '보통 싹이 올라온 후에 잎이 노래지는데 왜 이럴까요... 너무 물을 많이 줘서 그럴까요 ㅠㅠ?'
                        ' 뒤밭의 토양이 좋지 않은걸까요.... 강낭콩 키우는데 영향을 미치는 무언가일까요..? ',
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
                      const Text('0'),
                      IconButton(
                        icon: const Icon(Icons.comment_outlined),
                        onPressed: () {
                          // 댓글 버튼 클릭 시 동작 추가
                        },
                      ),
                      const Text('1'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
