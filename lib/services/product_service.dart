import 'package:connection_notifier/connection_notifier.dart' as n;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/controllers/msetting_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/product_model.dart';
import 'package:multi_vendor/screens/server_busy.dart';
import 'package:multi_vendor/services/cache_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ProductService {
  final _dio = Dio();

  Future<List<Product>> getProducts(int page, {bool retry = false}) async {
    var list = <Product>[];

    try {
      bool? isGrossist = Get.find<MSettingController>(tag: "setting").isGrossist;

      final body = {"page": page, "gros": (isGrossist) ? 1 : 0};

      printError(info: "isGrossist request : ${isGrossist}");

      print(body.toString());

      final response = await _dio.get(PRODUCT_ENDPOINT,
          queryParameters: body,
          options: Options(headers: {"Authorization": TOKEN}));
      List data = response.data;
      for (var item in data) {
        list.add(Product.fromJson(item));
      }
    } catch (e) {
      print("error get products : ${e}");

      bool hasInternet = await InternetConnectionChecker().hasConnection;
      if (hasInternet) {
        Get.offAll(() => const ServerBusyScreen());
      }

      //
    }
    return list;
  }

  Future<List<Product>> getProductsBySearch(String search) async {
    MSettingController _mSettingController = Get.find(tag: "setting");
    var list = <Product>[];
    try {
      final response = await _dio.post(SEARCH,
          queryParameters: {
            "search": search,
            "gros": _mSettingController.isGrossist ? 1 : 0
          },
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
    MSettingController _mSettingController = Get.find(tag: "setting");

    var list = <Product>[];
    try {
      final response = await _dio.get(PRODUCT_ENDPOINT,
          queryParameters: {
            "limit": 6,
            "page": page,
            "categorie": categorie,
            "gros": _mSettingController.isGrossist ? 1 : 0
          },
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
    MSettingController _mSettingController = Get.find(tag: "setting");

    try {
      final response = await _dio.get(PRODUCT_ENDPOINT,
          queryParameters: {
            "page": page,
            "gros": _mSettingController.isGrossist ? 1 : 0
          },
          options: Options(headers: {"Authorization": TOKEN}));
      var data = response.data;
      for (var item in data) {
        list.add(Product.fromJson(item));
      }
    } catch (e) {}
    return list;
  }
}
