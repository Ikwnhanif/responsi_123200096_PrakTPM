import 'package:responsi_123200096/service/base_network_meals.dart';

class MealsDataSource {
  static MealsDataSource instance = MealsDataSource();
  Future<Map<String, dynamic>> loadMeals(String text) {
    return BaseNetwork.get(text);
  }
}
