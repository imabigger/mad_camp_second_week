import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaist_summer_camp_second_week/auth/provider/auth_provider.dart';
import 'package:kaist_summer_camp_second_week/community/component/board.dart';
import 'package:kaist_summer_camp_second_week/community/model/post_model.dart';
import 'package:kaist_summer_camp_second_week/community/provider/post_provider.dart';

class CommunityWrittenPage extends ConsumerStatefulWidget {
  final String postId;

  const CommunityWrittenPage({Key? key, required this.postId}) : super(key: key);

  @override
  ConsumerState<CommunityWrittenPage> createState() => _CommunityWrittenPageState();
}

class _CommunityWrittenPageState extends ConsumerState<CommunityWrittenPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final post = ref.watch(postProvider).firstWhere((post) => post.id == widget.postId);
    final user = ref.watch(authProvider).user;

    return GestureDetector(
      onPanDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            Board.values[post.boardId].name,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                // 옵션 버튼 클릭 시 동작 추가
              },
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '서비스 / 지역',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.owner.username,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    post.createdAt.toString(),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            post.content,
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          // 이미지 리스트
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              IconButton(
                                icon: post.likesUid.contains(user?.id)
                                    ? Icon(Icons.favorite, color: Colors.red)
                                    : Icon(Icons.favorite_border, color: Colors.red),
                                onPressed: () async {
                                  // 좋아요 버튼 클릭 시 동작 추가
                                  if (user == null) {
                                    context.go('/auth');

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('로그인이 필요한 서비스입니다.'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                    return;
                                  }

                                  if (post.likesUid.contains(user.id)) {
                                    await ref.read(postProvider.notifier).unlikePost(postId: post.id, uid: user.id);
                                  } else {
                                    await ref.read(postProvider.notifier).likePost(postId: post.id, uid: user.id);
                                  }
                                  setState(() {});
                                },
                              ),
                              const SizedBox(width: 4),
                              Text(post.likesUid.length.toString()),
                              const SizedBox(width: 16),
                              Icon(Icons.chat_bubble_outline),
                              const SizedBox(width: 4),
                              Text(post.comments.length.toString()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(), // 구분선 추가
                          const SizedBox(height: 16),
                          if (post.comments.isEmpty)
                            Center(
                              child: Text(
                                '아직 댓글이 없어요.\n첫 댓글을 남겨보세요!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF8DB600)),
                              ),
                            ),
                          if (post.comments.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: post.comments.length,
                              itemBuilder: (context, index) {
                                final comment = post.comments[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.owner.username,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          comment.createdAt.toString(),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    const SizedBox(height: 8),
                                    Text(comment.content),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          // 카메라 아이콘 클릭 시 동작 추가
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: '댓글을 남겨보세요.',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          // 전송 아이콘 클릭 시 동작 추가
                          if (user == null) {
                            context.go('/auth');

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('로그인이 필요한 서비스입니다.'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                            return;
                          }

                          if (_controller.text.isEmpty) return;

                          await ref.read(postProvider.notifier).addComment(
                            postId: post.id,
                            content: _controller.text,
                          );

                          await ref.read(postProvider.notifier).onePostRefresh(postId: post.id);

                          setState(() {
                            _controller.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
