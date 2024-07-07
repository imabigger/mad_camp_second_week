import 'package:flutter/material.dart';

import '../model/plant_model.dart';

class SearchDetailPage extends StatelessWidget {
  final Plant plant;

  const SearchDetailPage({super.key, required this.plant});

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
          plant.name,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: plant.buildPlantInfo()
    );
  }
}