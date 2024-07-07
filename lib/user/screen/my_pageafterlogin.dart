import 'package:flutter/material.dart';

class MyPageAfterLogin extends StatelessWidget {
  const MyPageAfterLogin({super.key});

  @override
  Widget build(BuildContext context) {
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
          '마이페이지',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green.shade200,
                  child: const Icon(Icons.person, size: 30, color: Colors.white),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '홍길동 고객님',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'example@nongdam.com',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // 계정 설정 버튼 클릭 시 동작 추가
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('계정설정'),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: 0.6, // 60% 달성
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      strokeWidth: 12.0,
                      semanticsLabel: '60% 달성',
                    ),
                  ),
                  Image.asset(
                    'assets/i_flower.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '고객님은 현재 새싹 등급입니다.\n즐기 등급까지 40% 남았습니다 :)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32.0),
            GestureDetector(
              onTap: () {
                // 구매내역 버튼 클릭 시 동작 추가
              },
              child: ListTile(
                title: const Text('마켓'),
                subtitle: const Text('구매내역\n문의내역'),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                // 커뮤니티 작성글/댓글 버튼 클릭 시 동작 추가
              },
              child: ListTile(
                title: const Text('커뮤니티'),
                subtitle: const Text('커뮤니티 작성글/댓글'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
