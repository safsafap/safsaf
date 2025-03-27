import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/controllers/cart_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/cart_model.dart';

class CartItem extends StatefulWidget {
  final CartModel cartModel;
  final ValueChanged<int>? onUpdate;
  final bool isCart;
  CartItem({
    super.key,
    required this.cartModel,
    this.onUpdate,
    this.isCart = false,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late CartController _controller;

  ValueNotifier<int> quantity = ValueNotifier<int>(2);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantity.value = widget.cartModel.quantity;
    _controller = Get.find(tag: "cart");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                offset: const Offset(0, 3))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
            visible: widget.isCart,
            child: IconButton(
                onPressed: () {
                  _controller.removeFromCart(widget.cartModel);
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                )),
          ),
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(
                        IMAGES_ENDPOINT + widget.cartModel.imagePath),
                    fit: BoxFit.cover)),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.47,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.cartModel.name),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.cartModel.price} ${'DZA'.tr}",
                  style: const TextStyle(color: MAIN_COLOR),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(color: MAIN_COLOR),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      int limit =
                          int.tryParse(widget.cartModel.quantiteLimite) ?? 0;

                      if ((quantity.value == limit) ||
                          (widget.cartModel.stock == quantity.value)) {
                        Get.showSnackbar(GetSnackBar(
                          message: 'you have reached the quantity limit'.tr,
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.redAccent,
                        ));
                      }

                      if ((limit == 0 &&
                              quantity.value < widget.cartModel.stock) ||
                          (quantity.value < limit)) {
                        quantity.value++;

                        widget.cartModel.quantity = quantity.value;

                        if (widget.onUpdate != null) {
                          widget.onUpdate!(quantity.value);
                        }
                      }
                    },
                    icon: const Icon(Icons.add)),
                ValueListenableBuilder(
                    valueListenable: quantity,
                    builder: (context, value, child) => Text(value.toString())),
                IconButton(
                    onPressed: () {
                      if (quantity.value > widget.cartModel.min_commande) {
                        quantity.value--;
                        widget.cartModel.quantity = quantity.value;

                        if (widget.onUpdate != null) {
                          widget.onUpdate!(quantity.value);
                        }
                      }
                    },
                    icon: const Icon(Icons.remove)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
