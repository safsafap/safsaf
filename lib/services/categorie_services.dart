import 'package:dio/dio.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/categorie_model.dart';
import 'package:multi_vendor/models/slider_model.dart';

class CategorieServices {
  final _dio = Dio();

  Future<List<Category>> getCategorie() async {
    var list = <Category>[];

    try {
      final response = await _dio.get(CATEGORIES_ENDPOINT,
          options: Options(headers: {"Authorization": TOKEN}));
      List<dynamic> data = response.data;
      for (var item in data) {
        list.add(Category.fromJson(item));
      }
    } catch (e) {
    }
    return list;
  }
}
