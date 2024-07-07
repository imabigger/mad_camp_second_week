import 'package:flutter/material.dart';


class MyPrivateInfoSettingPage extends StatelessWidget {
  const MyPrivateInfoSettingPage({super.key});

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
          '개인 정보 관리',
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                width: double.infinity,
                color: Colors.green.shade100,
                child: const Text(
                  '개인정보는 상대방에게 노출되지 않습니다',
                  style: TextStyle(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: const Text('휴대전화 번호'),
              subtitle: const Text('홍길동'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 본인 인증 버튼 클릭 시 동작 추가
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('본인 인증이 필요해요'),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('이메일'),
              subtitle: const Text('east2west@naver.com'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // 이메일 클릭 시 동작 추가
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('비밀번호'),
              subtitle: const Text('●●●●●●●●'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // 비밀번호 클릭 시 동작 추가
              },
            ),
          ],
        ),
      ),
    );
  }
}
