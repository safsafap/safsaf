import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/models/fornisseur_model.dart';
import 'package:multi_vendor/models/product_fornisseur_model.dart';
import 'package:multi_vendor/models/product_model.dart';
import 'package:multi_vendor/screens/fornisseur_search.dart';
import 'package:multi_vendor/services/fornisseur_service.dart';
import 'package:multi_vendor/widgets/fornisseur_product_item.dart';
import 'package:multi_vendor/widgets/product_item.dart';

class FornisseurProductScreen extends StatefulWidget {
  FornisseurModel fornisseur;
  FornisseurProductScreen({Key? key, required this.fornisseur})
      : super(key: key);

  @override
  State<FornisseurProductScreen> createState() =>
      _FornisseurProductScreenState();
}

class _FornisseurProductScreenState extends State<FornisseurProductScreen> {
  List<ProductFornisseurModel> _listproducts = [];

  bool _loading = false;
  bool _visible = true;
  int _page_get = 1;

  final _controller = ScrollController();

  late GridView products;

  void Products() async {
    var l = await FornisseurService().getProductsByFornisseur(
        fornisseurId: widget.fornisseur.id, page: _page_get);

    _listproducts.addAll(l);
    _listproducts = _listproducts
        .fold<Map<int, ProductFornisseurModel>>({}, (map, obj) {
          map[obj.id] = obj;
          return map;
        })
        .values
        .toList();

    _loading = false;

    print("current page size : ${l.length}");
    print("current page grid: ${_listproducts.length}");

    // ✅ Check if the widget is still mounted before calling setState
    if (!mounted) return;

    setState(() {
      products = ProductsGridView();
      if (l.isNotEmpty) {
        _page_get = _page_get + 1;
        _visible = true;
      } else {
        _visible = false;
      }
    });

    l = [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    products = ProductsLoading();
    Products();
    _controller.addListener(() async {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 150 &&
          !_loading) {
        _loading = true;
        Products();
      }
    });
  }

  GridView ProductsGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        childAspectRatio: .53,
      ),
      itemBuilder: (context, position) {
        return Padding(
          key: UniqueKey(),
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: FornisseurProductItem(
            product: _listproducts[position],
          ),
        );
      },
      itemCount: _listproducts.length,
    );
  }

  GridView ProductsLoading() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: .58,
      ),
      itemBuilder: (context, position) {
        return ProductItem(
          loading: true,
          product: Product.emptyProduct(),
        );
      },
      itemCount: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text(widget.fornisseur.name),
          actions: [
            IconButton(
              onPressed: () {
                print("get to called");
                Get.to(() =>
                    FornisseurSearchScreen(fornisseur: widget.fornisseur));
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: products);
  }
}
