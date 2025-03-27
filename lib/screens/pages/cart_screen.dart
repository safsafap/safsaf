import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:multi_vendor/controllers/account_controller.dart';
import 'package:multi_vendor/controllers/cart_controller.dart';
import 'package:multi_vendor/controllers/msetting_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/cart_model.dart';
import 'package:multi_vendor/widgets/cart_item.dart';
import 'package:multi_vendor/widgets/login_dialog.dart';
import 'package:multi_vendor/widgets/order_dialog.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});
  ValueNotifier<List<CartModel>> cart = ValueNotifier([]);
  final AccountController _accountController = Get.find(tag: "account");
  double total = 0;

  void calculer() {
    total = 0;
    for (var element in cart.value) {
      total += double.parse(element.price) * element.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MSettingController>(
      tag: "setting",
      builder: (setting) {
        return GetBuilder<CartController>(
            tag: "cart",
            builder: (controller) {
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Text(
                      "Panier".tr,
                      style: const TextStyle(
                          fontSize: 24,
                          color: MAIN_COLOR,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      flex: 7,
                      child: FutureBuilder(
                          future: controller.getCart(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("Error ${snapshot.error!.toString()}"),
                              );
                            }
                            if (snapshot.hasData) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                cart.value = snapshot.data ?? [];
                              });
        
                              return snapshot.data!.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.shopping_cart,
                                            size: 50,
                                            color: MAIN_COLOR,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text("aucun produit dans la cart".tr),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: snapshot.data?.length,
                                      itemBuilder: (context, index) {
                                        return CartItem(
                                          key: UniqueKey(),
                                          isCart: true,
                                          cartModel: snapshot.data![index],
                                          onUpdate: (value) async {
                                            snapshot.data![index].quantity = value;
                                            cart.value = List.from(cart
                                                .value); // Update the cart value
        
                                            await controller
                                                .updateCart(snapshot.data![index]);
                                            cart.notifyListeners(); // Notify listeners after update
                                          },
                                        );
                                      });
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                    ),
                    Expanded(
                      flex: 1,
                      child: ValueListenableBuilder<List<CartModel>>(
                          valueListenable: cart,
                          builder: (context, counter, _) {
                            calculer();
                            return Visibility(
                              visible: counter.isNotEmpty,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Prix total".tr,
                                      style: const TextStyle(fontSize: 19)),
                                  Text(
                                    "$total ${'DZA'.tr}",
                                    style: const TextStyle(
                                        fontSize: 19, color: MAIN_COLOR),
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                    ValueListenableBuilder<List<CartModel>>(
                        valueListenable: cart,
                        builder: (context, counter, _) {
                          return Visibility(
                            visible: counter.isNotEmpty,
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(bottom: 14),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MAIN_COLOR,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(
                                        MediaQuery.sizeOf(context).width * .9, 50),
                                    maximumSize: Size(
                                        MediaQuery.sizeOf(context).width * .9, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_accountController.user != null) {
                                      Get.dialog(OrderDialog(
                                          carts: cart.value, total: total));
                                    } else {
                                      Get.dialog(const LoginDialog(),
                                          transitionCurve: Curves.fastOutSlowIn);
                                    }
                                  },
                                  child: Text("Ckeckout".tr)),
                            ),
                          );
                        })
                  ],
                ),
              );
            });
      }
    );
  }
}
