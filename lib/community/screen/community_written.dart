import 'package:flutter/material.dart';

class CommunityWrittenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          '물고 답해요',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '강낭콩을 심었는데 싹이 올라오지 않아요',
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
                      '홍길동',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '방금 전',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '싹이 올라온 후에 잎이 노래지는데 왜 이런걸까요 ... 너무 물을 많이 줘서 썩은 걸까요 ㅠㅠㅠ 텃밭을 가꿔보는 건 처음이라.. 강낭콩의 싹을 보기 어렵다는 얘기는 들었지만 노랗게 잎이 나는 건 처음이네요. 아시는 분은 좀 도와주시면 감사하겠습니다.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/plant_1.png',
                  height: 50,
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/plant_2.png',
                  height: 50,
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/plant_3.png',
                  height: 50,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.favorite_border),
                const SizedBox(width: 4),
                Text('1'),
                const SizedBox(width: 16),
                Icon(Icons.chat_bubble_outline),
                const SizedBox(width: 4),
                Text('0'),
              ],
            ),
            const SizedBox(height: 16),
            Divider(), // 구분선 추가
            const SizedBox(height: 16),
            Center(
              child: Text(
                '아직 댓글이 없어요.\n첫 댓글을 남겨보세요!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF8DB600)),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    // 카메라 아이콘 클릭 시 동작 추가
                  },
                ),
                Expanded(
                  child: TextField(
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
                  onPressed: () {
                    // 전송 아이콘 클릭 시 동작 추가
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
