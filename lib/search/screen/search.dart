import 'package:flutter/material.dart';
import 'package:kaist_summer_camp_second_week/search/model/plant_model.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search_detail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Plant> emptyPlants = [];
  List<Plant> filteredPlants = [];
  List<Plant> allPlants = plants.values.expand((innerMap) => innerMap.values).toList();

  @override
  void initState() {
    super.initState();
    filteredPlants = emptyPlants;
    _searchController.addListener(_filterPlants);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPlants);
    _searchController.dispose();
    super.dispose();
  }

  void _filterPlants() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPlants = allPlants.where((plant) {
        return plant.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), // AppBar 높이 조정
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // 화살표 버튼 클릭 시 동작 추가
            },
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '어떤 작물을 심고 싶으세요?',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // 더 둥근 모서리
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '지금 인기 있는 식물',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                _buildChip('상추'),
                _buildChip('아보카도'),
                _buildChip('대파'),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPlants.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(filteredPlants[index].name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchDetailPage(plant: filteredPlants[index]),
                            ),
                          );
                        },
                      ),
                      if (index < filteredPlants.length - 1) const Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.green[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      labelStyle: TextStyle(
        color: Colors.black,
      ),
    );
  }
}