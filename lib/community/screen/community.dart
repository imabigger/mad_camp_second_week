import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommunityPage extends StatefulWidget {
  final int boardId; // 0이 보드를 선택하지 않음을 의미함.1,2,3,4 까지 존재.

  const CommunityPage({this.boardId = 0,super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with SingleTickerProviderStateMixin {
  late int selectedIndex = widget.boardId; // 기본적으로 커뮤니티 페이지를 선택

  @override
  void didUpdateWidget(covariant CommunityPage oldWidget) {  // 상위 위젯의 상태가 변경 될때, 하위 위젯에도 알리는 함수임!! 이걸 써서 homescreen 이 변경될때 여기서도 변경되게함.
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(oldWidget.boardId != widget.boardId){
      selectedIndex = widget.boardId;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('묻고 답해요', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8.0),
                      const Text('강낭콩을 심었는데 싹이 올라오지 않아요', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '보통 싹이 올라온 후에 잎이 노래지는데 왜 이런걸까요 ... 너무 물을 많이 줘서 썩은 걸까요 ㅠㅠㅠ 텃밭 ...',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border, color: Colors.red),
                              onPressed: () {
                                // 좋아요 버튼 클릭 시 동작 추가
                              },
                            ),
                            const Text('0'),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.comment_outlined, color: Colors.black),
                              onPressed: () {
                                // 댓글 버튼 클릭 시 동작 추가
                              },
                            ),
                            const Text('1'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 글쓰기 버튼 클릭 시 동작 추가
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
