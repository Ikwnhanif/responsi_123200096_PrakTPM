import 'package:responsi_123200096/service/base_network_meals.dart';

class DetailDataSource {
  static DetailDataSource instance = DetailDataSource();
  Future<Map<String, dynamic>> loadDetail(String text) {
    return BaseNetwork.get(text);
  }
}
