import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Setting Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyAccountSettingPage(),
    );
  }
}

class MyAccountSettingPage extends StatelessWidget {
  const MyAccountSettingPage({super.key});

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
          '계정설정',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            child: Icon(Icons.camera_alt, size: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    '프로필 사진 설정',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0), // 왼쪽에 마진 추가
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '농담 활동명',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          // 수정 버튼 클릭 시 동작 추가
                        },
                        child: const Text(
                          '수정',
                          style: TextStyle(color: Colors.green, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0), // '홍길동' 텍스트 왼쪽에 마진 추가
                  child: Text(
                    '홍길동',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            ListTile(
              title: const Text('개인 정보 관리'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '본인 인증이 필요해요',
                    style: TextStyle(color: Colors.green),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
              onTap: () {
                // 개인 정보 관리 클릭 시 동작 추가
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('내 맞춤 정보 설정'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // 내 맞춤 정보 설정 클릭 시 동작 추가
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // 로그아웃 버튼 클릭 시 동작 추가
                  },
                  child: const Text('로그아웃', style: TextStyle(color: Colors.grey)),
                ),
                const VerticalDivider(
                  width: 20,
                  thickness: 1,
                  color: Colors.grey,
                ),
                TextButton(
                  onPressed: () {
                    // 계정 탈퇴 버튼 클릭 시 동작 추가
                  },
                  child: const Text('계정 탈퇴', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
