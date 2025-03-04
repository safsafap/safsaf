import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/product_model.dart';
import 'package:multi_vendor/translator/app-translations.dart';

import '../widgets/cart_bottomsheet.dart';

class ProductScreen extends StatelessWidget {
  Product product;
  ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                product.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * .4,
                  child: CachedNetworkImage(
                    fit: BoxFit.scaleDown,
                    imageUrl: '$IMAGES_ENDPOINT${product.imagePath}',
                  )),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                  visible: product.discount != '0',
                  child: Text(
                    '${product.realprice} ${'DZA'.tr}',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationColor:
                          Colors.red, // Optional: color of the line
                      decorationThickness:
                          2.0, // Optional: thickness of the line
                    ),
                  )),
              Text(
                "${product.price} ${'DZA'.tr}",
                style: TextStyle(
                    color: product.discount == '0'
                        ? Colors.black87
                        : Colors.redAccent,
                    fontSize: 24.5,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'description'.tr,
                    style: const TextStyle(
                        color: MAIN_COLOR,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                product.description,
                style:
                    const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(20),
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: MAIN_COLOR),
            onPressed: () async {
              await Get.bottomSheet(
                  CartBottomsheet(cartModel: product.toCartModel()));
            },
            child: Text(
              "Ajouter au panier".tr,
            ),
          ),
        ));
  }
}
