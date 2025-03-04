import 'package:dio/dio.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/order_after_model.dart';
import 'package:multi_vendor/models/order_model.dart';

class OrderServices {
  final _dio = Dio();

  Future<String> submitOrder(OrderModel orderModel) async {
    final response = await _dio.post(SUBMIT_ORDER,
        data: orderModel.toJson(),
        options: Options(headers: {'Authorization': TOKEN}));
    return response.data['pdf_path'];
  }

  Future<List<OrderAfterModel>> getOrders(int id) async {
    List<OrderAfterModel> list = [];
    try {
      var response = await _dio.get('$ORDERS_ENDPOINT+$id',
          options: Options(headers: {'Authorization': TOKEN}));
      for (var element in response.data) {
        list.add(OrderAfterModel.fromJson(element));
      }
    } catch (e) {
    }
    return list;
  }
}
