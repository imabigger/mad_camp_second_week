
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaist_summer_camp_second_week/community/model/post_model.dart';
import 'package:kaist_summer_camp_second_week/component/dio/provider/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:kaist_summer_camp_second_week/search/model/plant_model.dart';
import 'package:kaist_summer_camp_second_week/search/model/plant_with_view_model.dart';

final topPlantProvider = StateNotifierProvider<TopPlantNotifier, List<PlantWithViewModel>>((ref) {
  return TopPlantNotifier(ref: ref);
});

class TopPlantNotifier extends StateNotifier<List<PlantWithViewModel>>{
  StateNotifierProviderRef ref;

  TopPlantNotifier({required this.ref}) : super([]){
    getTopPlant();
  }

  Future<void> getTopPlant() async {
    final dio = ref.read(dioProvider);

    try {
      final response = await dio.get('/plants/topViews');
      final responseJson = response.data as List<dynamic>;

      List<String> names = responseJson.map((e) => e['name'] as String).toList();
      List<int> views = responseJson.map((e) => e['views'] as int).toList();


      List<PlantWithViewModel> topPlants = names.map((name) {
        for (var category in plants.values) {
          if (category.containsKey(name)) {
            return PlantWithViewModel(category[name]!, views[names.indexOf(name)]);
          }
        }
        throw Exception('Plant not found');
      }).toList();

      state = topPlants;
    } catch (e) {
      print('Get top plants failed: $e');
      throw Exception();
    }
  }

  Future<void> incrementViewCountPut({required String plantName}) async{
    try {
      final dio = ref.read(dioProvider);
      await dio.put('/plants/increment-views/$plantName');

      return;
    } catch (e) {
      print('[Increase view count failed]: $e');
      throw Exception();
    }
  }

}