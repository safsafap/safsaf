import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/user_model.dart';

class ProfileServices {
  var _dio = Dio();

  Future<void> updateProfile(User user) async {
    try {
      final response = await _dio.post(
        "$UPDATE_PROFILE${user.id}",
        data: user.toUpdateJson(),
        options: Options(headers: {'Authorization': TOKEN}),
      );
    } on DioError catch (e) {
      if (e.response != null) {
       
      } else {
      }
    }
  }
}
