import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/models/cart_model.dart';
import 'package:multi_vendor/models/order_model.dart';
import 'package:multi_vendor/screens/pdf_screen.dart';
import 'package:multi_vendor/services/cart_service.dart';
import 'package:multi_vendor/services/order_services.dart';

class CartController extends GetxController {
  final _cartService = CartService();
  final _orderService = OrderServices();

  Future<bool> isInCart(int id) async {
    try {
      return await _cartService.isInCart(id);
    } catch (e) {
    }
    return false;
  }

  Future<void> addToCart(CartModel cart) async {
    await _cartService.addToCart(cart);
    update();
  }

  Future<void> removeFromCart(CartModel cart) async {
    await _cartService.removeFromCart(cart.id);
    update();
  }

  Future<List<CartModel>> getCart() async {
    return await _cartService.getCart();
  }

  Future<void> updateCart(CartModel cart) async {
    await _cartService.updateCart(cart);
  }

  Future<double> calculateTotal() async {
    double total = 0;
    List<CartModel> cart = await _cartService.getCart();
    total = 0;
    for (var item in cart) {
      total += double.parse(item.price) * item.quantity;
    }
    return total;
  }

  CartModel? getCartByProduct(int id) {
    CartModel? cart;
    try {
      cart = _cartService.getCartByProduct(id);
    } catch (e) {
    }
    return cart;
  }

  Future<void> submitOrder(OrderModel order) async {
    try {
      String path = await _orderService.submitOrder(order);
      await _cartService.clearCart();
      update();
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.green,
        title: "Success".tr,
        message: "Order Submited Successfull".tr,
      ));
      Get.to(PdfScreen(path: path));
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.redAccent,
        title: "Error".tr,
        message: "Error Submiting Order".tr,
      ));
    }
  }
}
