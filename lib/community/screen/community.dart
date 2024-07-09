import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaist_summer_camp_second_week/auth/provider/auth_provider.dart';
import 'package:kaist_summer_camp_second_week/community/component/board.dart';
import 'package:kaist_summer_camp_second_week/community/provider/post_provider.dart';

class CommunityPage extends ConsumerStatefulWidget {
  final int boardId; // 0이 보드를 선택하지 않음을 의미함.1,2,3,4 까지 존재.

  const CommunityPage({this.boardId = 0, super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage>
    with SingleTickerProviderStateMixin {
  late int selectedIndex = widget.boardId; // 기본적으로 커뮤니티 페이지를 선택
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    ref.read(postProvider.notifier).getPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(postProvider.notifier).getPosts();
    }
  }

  @override
  void didUpdateWidget(covariant CommunityPage oldWidget) {
    // 상위 위젯의 상태가 변경 될때, 하위 위젯에도 알리는 함수임!! 이걸 써서 homescreen 이 변경될때 여기서도 변경되게함.
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.boardId != widget.boardId) {
      selectedIndex = widget.boardId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final postss = ref.watch(postProvider);
    final user = ref.watch(authProvider).user;

    final posts = postss.where((post) {
      if (selectedIndex == 0) {
        return true;
      } else {
        return post.boardId == selectedIndex;
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '커뮤니티',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // 검색 버튼 클릭 시 동작 추가
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              // 프로필 아이콘 클릭 시 동작 추가
              context.go('/user');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChip(0, '전체 보기'),
                  SizedBox(width: 8),
                  _buildChip(1, '묻고 답해요'),
                  SizedBox(width: 8),
                  _buildChip(2, '함께해요'),
                  SizedBox(width: 8),
                  _buildChip(3, '판매해요'),
                  SizedBox(width: 8),
                  _buildChip(4, '농담 이야기'),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(postProvider.notifier).postRefresh();
              },
              child: posts.isEmpty
                  ? Center(child: Text('게시글이 없습니다.'))
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];

                        return InkWell(
                          onTap: () {
                            context.go('/postDetail/${post.id}');
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
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 글쓰기 버튼 클릭 시 동작 추가
          context.go('/write');
        },
        child: const Icon(Icons.edit, color: Colors.white),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  Widget _buildChip(int index, String label) {
    return GestureDetector(
      onTap: () => _onChipTap(index),
      child: Chip(
        label: Text(label),
        backgroundColor: selectedIndex == index ? Colors.lightGreen : null,
      ),
    );
  }

  void _onChipTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
