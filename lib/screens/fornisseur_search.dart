import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/controllers/index_controller.dart';
import 'package:multi_vendor/models/fornisseur_model.dart';
import 'package:multi_vendor/services/fornisseur_service.dart';
import 'package:multi_vendor/services/product_service.dart';

import '../models/product_model.dart';
import '../widgets/product_item.dart';

class FornisseurSearchScreen extends StatelessWidget {
  FornisseurModel fornisseur;
  FornisseurSearchScreen({super.key, required this.fornisseur});

  ValueNotifier<String> searchText = ValueNotifier("");
  Timer? _searchDebounce;
  final ScrollController _scrollController = ScrollController();
  FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 100,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextField(
                  autofocus: true,
                  controller: _searchController,
                  onChanged: (value) {
                    if (_searchDebounce?.isActive ?? false)
                      _searchDebounce!.cancel();
                    _searchDebounce = Timer(Duration(milliseconds: 500), () {
                      searchText.value = value.toString();
                    });
                  },
                  onTap: () {},
                  selectionHeightStyle: BoxHeightStyle.tight,
                  decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 18,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          searchText.value = "";
                        },
                      ),
                      hintText: "Search for a product".tr,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      )),
                )),
          ),
        ),
        body: ValueListenableBuilder<String>(
          valueListenable: searchText,
          builder: (context, value, child) {
            return FutureBuilder(
              future: FornisseurService().searchPrductsByFornisseur(
                  fornisseurId: fornisseur.id, name: value),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      childAspectRatio: .53,
                    ),
                    itemBuilder: (context, position) {
                      return ProductItem(
                        loading: true,
                        product: Product.emptyProduct(),
                      );
                    },
                    itemCount: 8,
                    physics: const NeverScrollableScrollPhysics(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('No products found'.tr));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products found'.tr));
                } else {
                  _scrollController.addListener(() async {
                    await Future.delayed(Duration(milliseconds: 100));
                    _focusNode.unfocus();
                  });
                  return GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      childAspectRatio: .53,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5),
                      child: ProductItem(product: snapshot.data![index]),
                    ),
                  );
                }
              },
            );
          },
        ));
  }
}
