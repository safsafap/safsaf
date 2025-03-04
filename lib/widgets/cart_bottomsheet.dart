import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/controllers/cart_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/cart_model.dart';
import 'package:multi_vendor/models/product_model.dart';
import 'package:multi_vendor/widgets/cart_item.dart';
import 'package:should_rebuild/should_rebuild.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartBottomsheet extends StatefulWidget {
  CartModel cartModel;
  bool inCart;
  CartBottomsheet({super.key, required this.cartModel, this.inCart = false});

  @override
  State<CartBottomsheet> createState() => _CartBottomsheetState();
}

class _CartBottomsheetState extends State<CartBottomsheet> {
  late CartController _cartController;
  late ValueNotifier<int> count;

  @override
  void initState() {
    super.initState();
    _cartController = Get.find(tag: "cart");
    getData();
  }

  void getData() {
    widget.cartModel = _cartController.getCartByProduct(widget.cartModel.id) ??
        widget.cartModel;
    count = ValueNotifier(widget.cartModel.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        backgroundColor: Colors.white,
        enableDrag: true,
        constraints: const BoxConstraints(
          minHeight: 300,
        ),
        onClosing: () {},
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Prix total".tr, style: TextStyle(fontSize: 19)),
                  ValueListenableBuilder<int>(
                      valueListenable: count,
                      builder: (context, counter, _) {
                        return Text(
                          "${(double.parse(widget.cartModel.price) * counter)} ${'DZA'.tr}",
                          style:
                              const TextStyle(fontSize: 19, color: MAIN_COLOR),
                        );
                      }),
                ],
              ),
              widget.inCart
                  ? CartItem(
                      cartModel: widget.cartModel,
                      onUpdate: (counter) async {
                        widget.cartModel.quantity = counter;
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          count.value = counter;
                        });
                        await _cartController.updateCart(widget.cartModel);
                      },
                    )
                  : CartItem(
                      cartModel: widget.cartModel,
                      onUpdate: (counter) async {
                        widget.cartModel.quantity = counter;
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          count.value = counter;
                        });
                      },
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MAIN_COLOR,
                          foregroundColor: Colors.white,
                          minimumSize:
                              Size(MediaQuery.sizeOf(context).width * .43, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () async {
                        await _cartController.addToCart(widget.cartModel);
                        Get.back();
                        Get.showSnackbar(GetSnackBar(
                          message: "Produit ajouté au panier".tr,
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ));
                      },
                      child: Text("Ajouter".tr)),
                  OutlinedButton(
                    onPressed: () async {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        minimumSize:
                            Size(MediaQuery.sizeOf(context).width * .43, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text("Anuller".tr),
                  )
                ],
              )
            ],
          );
        });
  }
}
