import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/controllers/account_controller.dart';
import 'package:multi_vendor/controllers/cart_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/cart_model.dart';
import 'package:multi_vendor/models/order_model.dart';

class OrderDialog extends StatelessWidget {
  List<CartModel> carts;
  double total;
  OrderDialog({super.key, required this.carts, required this.total});
  final CartController _cartController = Get.find(tag: 'cart');
  final AccountController _accountController = Get.find(tag: 'account');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 80,
            width: 80,
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: MAIN_COLOR, shape: BoxShape.circle),
            child: const Icon(
              Icons.shopping_cart_checkout,
              color: Colors.white,
              size: 45,
            ),
          ),
          Text(
            "Order".tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text("are you sure to make this order ?".tr),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();

            await _cartController.submitOrder(OrderModel.fromCart(
                list: carts,
                total: total,
                id: _accountController.user?.id ?? 0));
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: MAIN_COLOR,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Text(
            "Order".tr,
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Text(
            "Cancell".tr,
            style: TextStyle(color: Colors.black54),
          ),
        )
      ],
    );
  }
}
