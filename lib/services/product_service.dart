import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/product_model.dart';
import 'package:multi_vendor/screens/server_busy.dart';

class ProductService {
  final _dio = Dio();

  Future<List<Product>> getProducts(int page,{bool retry=false}) async {
    var list = <Product>[];

    try {
      final response = await _dio.get(PRODUCT_ENDPOINT,
          queryParameters: {"page": page},
          options: Options(headers: {"Authorization": TOKEN}));
      List data = response.data;
      for (var item in data) {
        list.add(Product.fromJson(item));
      }
    } catch (e) {
      if (retry) {
              Get.offAll(ServerBusyScreen());

      }else{
        list = await getProducts(page,retry:true);
        return  list;
      }
    }
    return list;
  }

  Future<List<Product>> getProductsBySearch(String search) async {
    var list = <Product>[];
    try {
      final response = await _dio.post(SEARCH + "?search=$search",
          options: Options(headers: {"Authorization": TOKEN}));
      List data = response.data;
      for (var item in data) {
        item["image_path"] = 'images/' + item["image_path"];
        list.add(Product.fromJson(item));
      }
    } catch (e) {}

    return list;
  }

  Future<List<Product>> getProductsByCategorie(
      {required int page, required int categorie}) async {
    var list = <Product>[];
    try {
      final response = await _dio.get(PRODUCT_ENDPOINT,
          queryParameters: {"limit": 6, "page": page, "categorie": categorie},
          options: Options(headers: {"Authorization": TOKEN}));
      List<dynamic> data = response.data;
      for (var item in data) {
        list.add(Product.fromJson(item));
      }
    } catch (e) {}

    return list;
  }

  Future<List<Product>> getProductsDiscount(int page) async {
    var list = <Product>[];
    try {
      final response = await _dio.get(PRODUCT_ENDPOINT + "?page=1",
          options: Options(headers: {"Authorization": TOKEN}));
      var data = response.data;
      for (var item in data) {
        list.add(Product.fromJson(item));
      }
    } catch (e) {}
    return list;
  }
}
