import 'package:flutter/material.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search_result.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NongDam'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              // 프로필 버튼 클릭 시 동작 추가
            },
          ),
          ElevatedButton(
            onPressed: () {
              // 가입 버튼 클릭 시 동작 추가
            },
            child: const Text( '농담가입', style: TextStyle(fontSize: 13), ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF7C9A36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              minimumSize: Size(80, 20), // 버튼의 최소 크기 설정 (너비, 높이)
            ),
          ),


          const SizedBox(width: 8), // 오른쪽 여백 추가
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 검색창
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '어떤 작물을 심고 싶으세요?',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // 카테고리 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  CategoryIcon(label: '전체 보기', imagePath: 'assets/i_gridview.png', onTap: () => _navigateToSearchResult(context, '전체 보기'),),
                  CategoryIcon(label: '곡물', imagePath: 'assets/i_crop.png', onTap: () => _navigateToSearchResult(context, '곡물'),),
                  CategoryIcon(label: '채소', imagePath: 'assets/i_vege.png', onTap: () => _navigateToSearchResult(context, '채소'),),
                  CategoryIcon(label: '과일', imagePath: 'assets/i_fruit.png', onTap: () => _navigateToSearchResult(context, '과일'),),
                  CategoryIcon(label: '꽃', imagePath: 'assets/i_flower.png', onTap: () => _navigateToSearchResult(context, '꽃'),),
                  CategoryIcon(label: '허브', imagePath:  'assets/i_herb.png', onTap: () => _navigateToSearchResult(context, '허브'),),
                  CategoryIcon(label: '견과류', imagePath: 'assets/i_nuts.png', onTap: () => _navigateToSearchResult(context, '견과류'),),
                  CategoryIcon(label: '다육식물', imagePath: 'assets/i_cactus.png', onTap: () => _navigateToSearchResult(context, '다육식물'),),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 인기 식물 섹션
            SectionTitle(title: '농담 인기 식물'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PlantList(),
            ),
            // 커뮤니티 섹션
            SectionTitle(title: '농담 커뮤니티에 물어보세요', showMore: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PlantList(),
            ),
            // 함께해요 섹션
            SectionTitle(title: '함께해요', showMore: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PlantList(),
            ),
            // 판매해요 섹션
            SectionTitle(title: '판매해요', showMore: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PlantList(),
            ),
            // 이야기 섹션
            SectionTitle(title: '농담 이야기', showMore: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PlantList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny),
            label: '날씨',
          ),
        ],
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;

  const CategoryIcon({Key? key, required this.label, required this.imagePath, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(imagePath), // 이미지를 표시
            ),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

void _navigateToSearchResult(BuildContext context, String label) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SearchResultPage(label: label),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final bool showMore;

  const SectionTitle({required this.title, this.showMore = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (showMore)
            TextButton(
              onPressed: () {},
              child: const Text('전체보기', style: TextStyle(color: Colors.green)),
            ),
        ],
      ),
    );
  }
}

class PlantList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          PlantCard(),
          PlantCard(),
          PlantCard(),
          PlantCard(),
          PlantCard(),
          PlantCard(),
        ],
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/i_flower.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text('상추', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const Text('240,840명 검색', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}