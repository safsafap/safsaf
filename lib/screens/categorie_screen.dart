import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/categorie_model.dart';
import 'package:multi_vendor/models/product_model.dart';
import 'package:multi_vendor/services/categorie_services.dart';
import 'package:multi_vendor/services/product_service.dart';
import 'package:multi_vendor/widgets/product_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategorieScreen extends StatefulWidget {
  Category category;
  CategorieScreen({super.key, required this.category});

  @override
  State<CategorieScreen> createState() => _CategorieScreenState();
}

class _CategorieScreenState extends State<CategorieScreen> {
  final _controller = ScrollController();
  int _currentPage = 1;
  List<Product> _list = [];
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadProduct();
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 50) {
        LoadProduct();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.category.name,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        body: _loading ? LodaingProduct() : ListProduct());
  }

  void LoadProduct() async {
    var l = await ProductService().getProductsByCategorie(
        page: _currentPage, categorie: widget.category.id);
    _list.addAll(l);
    _list = _list
        .fold<Map<int, Product>>({}, (map, obj) {
          map[obj.id] = obj; // استخدام id كمفتاح في الخريطة
          return map;
        })
        .values
        .toList();
    _currentPage++;
    _loading = false;
    setState(() {});
  }

  Widget ListProduct() {
    return _list.isEmpty
        ? Center(
            child: Text("${"No product in".tr} ${widget.category.nameFr}"),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GridView.builder(
              controller: _controller,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                childAspectRatio: .53,
              ),
              itemCount: _list.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5),
                child: ProductItem(product: _list[index]),
              ),
            ),
          );
  }

  Widget LodaingProduct() {
    return const Center(
      child: CircularProgressIndicator(
        color: MAIN_COLOR,
      ),
    );
  }
}
