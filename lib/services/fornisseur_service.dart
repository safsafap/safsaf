import 'package:dio/dio.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/fornisseur_model.dart';
import 'package:multi_vendor/models/product_fornisseur_model.dart';

class FornisseurService {
  final _dio = Dio();

  Future<List<FornisseurModel>> getFornisseur() async {
    List<FornisseurModel> list = [];
    try {
      final response = await _dio.get(FORNISSEUR_ENDPOINT,
          options: Options(headers: {"Authorization": TOKEN}));

      for (var item in response.data) {
        list.add(FornisseurModel.fromJson(item));
      }
    } catch (e) {
      print(e);
    }
    return list;
  }

  Future<List<ProductFornisseurModel>> getProductsByFornisseur(
      {required int fornisseurId, required int page}) async {
    List<ProductFornisseurModel> list = [];
    try {
      final response = await _dio.get(PRODUCT_ENDPOINT,
          queryParameters: {"page": page, "grossist": fornisseurId},
          options: Options(headers: {"Authorization": TOKEN}));

      print("response f-products: ${response.data}");

      for (var item in response.data) {
        list.add(ProductFornisseurModel.fromJson(item));
      }
    } catch (e) {
      print(e);
    }
    return list;
  }

  Future<List<ProductFornisseurModel>> searchPrductsByFornisseur(
      {required int fornisseurId, required String name}) async {
    List<ProductFornisseurModel> list = [];
    print("search name : $name");
    try {
      final response = await _dio.post(GROSIST_SEARCH,
          queryParameters: {"search": name.toString(), "id": fornisseurId},
          options: Options(headers: {"Authorization": TOKEN}));

      for (var item in response.data) {
        ProductFornisseurModel p = ProductFornisseurModel.fromJson(item);
        p.imagePath = "images/${p.imagePath}";
        list.add(p);
      }
      print("response f-products: ${response.data}");
    } on DioException catch (e) {
      print("error : ");
      print(e.response?.data.toString());
    }
    return list;
  }
}
