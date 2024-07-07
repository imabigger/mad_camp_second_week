import 'package:flutter/material.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

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
          '식물 검색',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // 검색 버튼 클릭 시 동작 추가
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryIcon('assets/i_crop.png', '곡물'),
                _buildCategoryIcon('assets/i_vege.png', '채소'),
                _buildCategoryIcon('assets/i_fruit.png', '과일'),
                _buildCategoryIcon('assets/i_flower.png', '꽃'),
                _buildCategoryIcon('assets/i_herb.png', '허브'),
                _buildCategoryIcon('assets/i_nuts.png', '견과류'),
                _buildCategoryIcon('assets/i_cactus.png', '다육식물'),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: const [
                ListTile(title: Text('쌀')),
                ListTile(title: Text('밀')),
                ListTile(title: Text('보리')),
                ListTile(title: Text('옥수수')),
                ListTile(title: Text('귀리')),
                ListTile(title: Text('호밀')),
                ListTile(title: Text('수수')),
                ListTile(title: Text('기장')),
                ListTile(title: Text('완두콩')),
                ListTile(title: Text('메밀')),
                ListTile(title: Text('렌틸콩')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(String imagePath, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(imagePath),
            ),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
