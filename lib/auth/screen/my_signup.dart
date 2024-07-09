import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaist_summer_camp_second_week/auth/model/auth.dart';
import 'package:kaist_summer_camp_second_week/auth/provider/auth_provider.dart';

class MySignUpPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends ConsumerState<MySignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
    super.dispose();
  }

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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              context.pop();
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
                        child:
                            Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                          child: Icon(Icons.camera_alt,
                              size: 15, color: Colors.black),
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
                  controller: nameController,
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
                  controller: emailController,
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
                  controller: passwordController,
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
                  controller: passwordCheckController,
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
                  onPressed: () async {
                    // 회원가입 완료 버튼 클릭 시 동작 추가
                    String email, username, password, passwordCheck;
                    email = emailController.text;
                    username = nameController.text;
                    password = passwordController.text;
                    passwordCheck = passwordCheckController.text;

                    if (email.isEmpty || username.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('모든 항목을 입력해주세요.'),
                        ),
                      );
                      return;
                    } else if(password != passwordCheck){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('비밀번호가 일치하지 않습니다.'),
                        ),
                      );
                      return;
                    }

                    bool isRegisterSuccess = await ref
                        .read(authProvider.notifier)
                        .register(
                            email: email,
                            username: username,
                            password: password);
                    if (!isRegisterSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('회원가입에 실패했습니다. 다시 시도해주세요.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 16),
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
      ),
    );
  }
}
