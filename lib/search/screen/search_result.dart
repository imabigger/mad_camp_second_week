import 'package:flutter/material.dart';
import 'package:kaist_summer_camp_second_week/search/model/plant_model.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search.dart';

class SearchResultPage extends StatefulWidget {
  final String label;

  const SearchResultPage({super.key, required this.label});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late String currentLabel;
  late ScrollController _scrollController;
  Map<String, GlobalKey> _keys = {};

  @override
  void initState() {
    super.initState();
    currentLabel = widget.label == '전체 보기' ? '곡물' : widget.label;
    _scrollController = ScrollController();
    _keys = {
      '곡물': GlobalKey(),
      '채소': GlobalKey(),
      '과일': GlobalKey(),
      '꽃': GlobalKey(),
      '허브': GlobalKey(),
      '견과류': GlobalKey(),
      '다육식물': GlobalKey(),
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  void updateCategory(String label) {
    setState(() {
      currentLabel = label == '전체 보기' ? '곡물' : label;
      _scrollToSelected();
    });
  }

  void _scrollToSelected() {
    final keyContext = _keys[currentLabel]?.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 200),
        alignment: 0.5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> plantList = plants[currentLabel]?.keys.toList() ?? [];

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              ); // 검색 버튼 클릭 시 동작 추가
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
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryIconWithPadding('assets/i_crop.png', '곡물'),
                _buildCategoryIconWithPadding('assets/i_vege.png', '채소'),
                _buildCategoryIconWithPadding('assets/i_fruit.png', '과일'),
                _buildCategoryIconWithPadding('assets/i_flower.png', '꽃'),
                _buildCategoryIconWithPadding('assets/i_herb.png', '허브'),
                _buildCategoryIconWithPadding('assets/i_nuts.png', '견과류'),
                _buildCategoryIconWithPadding('assets/i_cactus.png', '다육식물'),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: plantList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(plantList[index]),
                    ),
                    if (index < plantList.length - 1) const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIconWithPadding(String imagePath, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CategoryIcon(
        key: _keys[label],
        label: label,
        imagePath: imagePath,
        isSelected: currentLabel == label,
        onTap: () => updateCategory(label),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryIcon({
    Key? key,
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

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
              border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
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
