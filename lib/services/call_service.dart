import 'package:dio/dio.dart';
import 'package:multi_vendor/main_constant.dart';

class CallService {
  final _dio = Dio();

  Future<String> getNumber() async {
    var response = await _dio.get(PHONE,
        options: Options(headers: {'Authorization': TOKEN}));

    return response.data.toString();
  }
}
