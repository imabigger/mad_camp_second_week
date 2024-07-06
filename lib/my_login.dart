import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyLoginPage(),
    );
  }
}

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({super.key});

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
          '로그인',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: const Text(
                '로고 올 자리',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 32.0),
            TextField(
              decoration: InputDecoration(
                labelText: '이메일',
                hintText: 'example@nongdam.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: '비밀번호',
                hintText: '비밀번호를 입력해주세요.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // 이메일 로그인 버튼 클릭 시 동작 추가
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                '이메일 로그인',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // 이메일 찾기 버튼 클릭 시 동작 추가
                  },
                  child: const Text('이메일 찾기'),
                ),
                const Text('|', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () {
                    // 비밀번호 찾기 버튼 클릭 시 동작 추가
                  },
                  child: const Text('비밀번호 찾기'),
                ),
                const Text('|', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () {
                    // 회원가입 버튼 클릭 시 동작 추가
                  },
                  child: const Text('회원가입'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                // 카카오 로그인 버튼 클릭 시 동작 추가
              },
              icon: const Icon(Icons.chat_bubble, color: Colors.black),
              label: const Text('카카오로 시작'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.yellow,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton.icon(
              onPressed: () {
                // 네이버 로그인 버튼 클릭 시 동작 추가
              },
              icon: const Icon(Icons.chat_bubble, color: Colors.white),
              label: const Text('네이버로 시작'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
