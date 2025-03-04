import 'package:dio/dio.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/slider_model.dart';

class SliderServices {
  final _dio = Dio();

  Future<List<SliderModel>> getSliders() async {
    var list = <SliderModel>[];

    try {
      final response = await _dio.get(SLIDERS_ENDPOINT,
          options: Options(headers: {"Authorization": TOKEN}));
      List<dynamic> data = response.data;
   
      for (var item in data) {
        list.add(SliderModel.fromJson(item));
      }

    } catch (e) {
    }
    return list;
  }
}
