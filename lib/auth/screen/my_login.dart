import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaist_summer_camp_second_week/auth/model/auth.dart';

import '../provider/auth_provider.dart';

class MyLoginPage extends ConsumerStatefulWidget {
  const MyLoginPage({super.key});

  @override
  ConsumerState<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends ConsumerState<MyLoginPage> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isLoggedIn == true) {
        context.go('/user');
      }
    });

    return GestureDetector(
      onPanDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
                context.go('/');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green.withOpacity(0),
                child: Image.asset('assets/default_nongdam_image.png'),
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: emailTextEditingController,
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
                controller: passwordTextEditingController,
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
                onPressed: () async {
                  // 이메일 로그인 버튼 클릭 시 동작 추가
                  // test code
                  if(emailTextEditingController.text.isEmpty || passwordTextEditingController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('모든 항목을 입력해주세요.'),
                      ),
                    );
                    return;
                  }

                  var isLoginSuccess = await ref.read(authProvider.notifier).logInWithEmail(email: 'bigger1@gmail.com', password: '1234');
                  if(!isLoginSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('로그인 실패.'),
                        ));
                  }
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
                      context.go('/auth/login/find/email');
                    },
                    child: const Text('이메일 찾기'),
                  ),
                  const Text('|', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      // 비밀번호 찾기 버튼 클릭 시 동작 추가
                      context.go('/auth/login/find/password');
                    },
                    child: const Text('비밀번호 찾기'),
                  ),
                  const Text('|', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      // 회원가입 버튼 클릭 시 동작 추가
                      context.go('/auth/signup');
                    },
                    child: const Text('회원가입'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () {
                  // 카카오 로그인 버튼 클릭 시 동작 추가
                  var isLoginSuccess = ref.read(authProvider.notifier).logInWithKaKao();

                },
                icon: ImageIcon(
                  AssetImage('assets/kakao_logo_15px.png'),
                  color: Colors.black,
                ),
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
                onPressed: () async {
                  // 네이버 로그인 버튼 클릭 시 동작 추가
                  var isLoginSuccess = await ref.read(authProvider.notifier).logInWithNaver();
                },
                icon: ImageIcon(
                  AssetImage('assets/naver_logo_15px.png'),
                  color: Colors.white,
                ),
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
      ),
    );
  }
}
