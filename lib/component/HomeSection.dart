import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaist_summer_camp_second_week/community/component/board.dart';
import 'package:kaist_summer_camp_second_week/community/model/post_model.dart';
import 'package:kaist_summer_camp_second_week/community/provider/board_provider.dart';
import 'package:kaist_summer_camp_second_week/community/provider/post_provider.dart';

class HomeCommunitySection extends ConsumerWidget {
  final String title;
  final bool showMore;
  final void Function(int)? onAllShowClicked;
  final int boardIndex;
  final List<PostModel> posts;

  HomeCommunitySection({
    required this.title,
    this.showMore = false,
    this.onAllShowClicked,
    required this.boardIndex,
    required this.posts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              if (showMore)
                TextButton(
                  onPressed: () {
                    onAllShowClicked!(boardIndex!);
                  },
                  child: const Text('전체보기', style: TextStyle(color: Colors.green)),
                ),
            ],
          ),
        ),
        if(posts.isNotEmpty)
        SizedBox(
          height: 174, // 적절한 높이를 설정합니다.
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },
            itemBuilder: (context, index) {
              return InkWell(onTap: (){
                ref.read(boardPostProvider(Board.values[boardIndex]).notifier).increaseViewCountPut(postId: posts[index].id);
                ref.read(postProvider.notifier).getFrontPosts(posts[index]);
                context.go('/postDetail/${posts[index].id}');
              },child: PostListItem(post: posts[index]));
            },
          ),
        ),
      ],
    );
  }
}

class PostListItem extends StatelessWidget {
  final PostModel post;

  const PostListItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: post.imageUrl.isNotEmpty
                    ? Image.network(
                  '${dotenv.env['imageServerPath']}${post.imageUrl[0]}',
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/default_nongdam_image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            post.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '조회수 ${post.viewCount} · 좋아요 ${post.likesUid.length}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}