import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignUp Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MySignUpPage(),
    );
  }
}

class MySignUpPage extends StatelessWidget {
  const MySignUpPage({super.key});

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
          '회원가입',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(height: 32.0),
              TextField(
                decoration: InputDecoration(
                  labelText: '이름을 입력해주세요',
                  hintText: '실명으로 입력해주세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                '타인 명의로 가입 시 계정이 정지되고 재가입이 불가능합니다.',
                style: TextStyle(fontSize: 12, color: Colors.green),
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: '이메일을 입력해주세요',
                  hintText: '사용 가능한 이메일',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: '비밀번호를 설정해주세요',
                  hintText: '비밀번호를 입력해주세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: '비밀번호를 재확인해주세요',
                  hintText: '위의 비밀번호와 같아야 합니다',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // 회원가입 완료 버튼 클릭 시 동작 추가
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  '회원가입 완료',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
