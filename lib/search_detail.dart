import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SearchDetail Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SearchDetailPage(title: '쌀'),
    );
  }
}

class SearchDetailPage extends StatelessWidget {
  final String title;

  const SearchDetailPage({super.key, required this.title});

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
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/rice.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '1. 기후 조건',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• 온도: 20~35도의 따뜻한 기후\n• 강수량: 강수량이 많거나 관개 시스템이 잘 갖춰진 지역\n• 일조량: 매일 최소 6~8시간 충분한 일조'),
            const SizedBox(height: 16.0),
            const Text(
              '2. 토양 조건',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• 토양 유형: 점질토나 사질토\n• pH 수준: 중성 또는 약산성(pH 5.5~7.0) 토양\n• 배수와 보수: 물을 잘 보유하면서도 적절한 배수'),
            const SizedBox(height: 16.0),
            const Text(
              '3. 재배 방법',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• 모판 준비: 좋은 품질의 종자 선택, 적절한 시기에 파종\n• 이앙: 모를 일정한 간격으로 이앙하여 균일한 생장 유도\n• 관리: 논을 잘 관리하여 생장 동안 충분한 수분 공급\n• 비료: 주기적 시비 작업'),
            const SizedBox(height: 16.0),
            const Text(
              '4. 수확 및 후속 관리',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• 수확 시기: 완전히 익은 시기에 수확\n• 건조: 수확한 쌀을 적절히 건조시켜 저장 중 품질 유지\n• 저장: 적정한 해충으로부터 보호하기 위한 조건'),
            const SizedBox(height: 16.0),
            const Text(
              '5. 기술 및 자원',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• 기계화: 트랙터, 콤바인 등의 기계화가 가능합니다.\n• 관개 시스템: 안정적인 물 공급을 위한 관개 시스템 구축'),
          ],
        ),
      ),
    );
  }
}
