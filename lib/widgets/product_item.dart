import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:multi_vendor/controllers/cart_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/product_model.dart';
import 'package:multi_vendor/screens/product_screen.dart';
import 'package:multi_vendor/widgets/cart_bottomsheet.dart';
import 'package:ribbon_widget/ribbon_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

// class ProductItem extends StatefulWidget {
//   Product product;
//   bool loading;
//   ProductItem({super.key, required this.product, this.loading = false});

//   @override
//   State<ProductItem> createState() => _ProductItemState();
// }

// class _ProductItemState extends State<ProductItem> {
//   @override
//   void initState() {
//     // TODO: implement initState

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Skeletonizer(
//       enabled: widget.loading,
//       child: GestureDetector(
//         onTap: () {
//           Get.to(
//             () => ProductScreen(
//               product: widget.product,
//             ),
//           );
//         },
//         child: Stack(
//           children: [
//             Positioned(
//                 top: 10,
//                 right: 7,
//                 bottom: 0,
//                 left: 0,
//                 child: widget.product.newer == 0 ? _content() : _withRinbon()),
//             Visibility(
//               visible: widget.product.discount != '0',
//               child: Positioned(
//                   top: 0,
//                   right: 0,
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.redAccent),
//                     child: Text(
//                       "- ${widget.product.discount} ${widget.product.discountType == 'fixed' ? 'DA'.tr : '%'}",
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   )),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _withRinbon() {
//     return Ribbon(
//         nearLength: 0,
//         farLength: widget.product.newer == 0 ? 0 : 80,
//         title: widget.product.newer == 0 ? '' : 'Nouveau'.tr,
//         titleStyle: const TextStyle(fontSize: 16),
//         color: Colors.amber,
//         child: _content());
//   }

//   Widget _content() {
//     return Container(
//       decoration: widget.loading
//           ? null
//           : BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.white,
//               border: Border.all(color: MAIN_COLOR, width: 1.5)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Container(
//             height: MediaQuery.sizeOf(context).height * 0.18,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                     onError: (exception, stackTrace) {
//                       printError(info: "error : $exception");
//                     },
//                     image: CachedNetworkImageProvider(
//                         IMAGES_ENDPOINT + widget.product.imagePath))),
//           ),
//           Text(
//             widget.product.name,
//             overflow: TextOverflow.ellipsis,
//             textDirection: TextDirection.ltr,
//             style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//             maxLines: 2,
//           ),
//           Visibility(
//               visible: widget.product.discount != '0',
//               child: Text(
//                 '${widget.product.realprice} ${'DZA'.tr}',
//                 style: const TextStyle(
//                   decoration: TextDecoration.lineThrough,
//                   decorationColor: Colors.red, // Optional: color of the line
//                   decorationThickness: 2.0, // Optional: thickness of the line
//                 )
//               )),
//           Text(
//             "${widget.product.price} ${'DZA'.tr}",
//             style: TextStyle(
//                 color: widget.product.discount == '0'
//                     ? Colors.black87
//                     : Colors.redAccent,
//                 fontSize: 17.5,
//                 fontWeight: FontWeight.bold),
//           ),
//           _cartButton()
//         ],
//       ),
//     );
//   }

//   Widget _cartButton() => Padding(
//         padding: const EdgeInsets.only(right: 4.0, left: 0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             GetBuilder<CartController>(
//                 tag: "cart",
//                 builder: (controller) {
//                   return FutureBuilder<bool>(
//                       future: controller.isInCart(widget.product.id),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.done) {
//                           if (snapshot.data!) {
//                             return IconButton(
//                               icon: const Icon(
//                                 Icons.shopping_cart,
//                                 color: Colors.grey,
//                               ),
//                               onPressed: () {
//                                 Get.bottomSheet(
//                                     backgroundColor: Colors.white,
//                                     enableDrag: true,
//                                     CartBottomsheet(
//                                       cartModel: widget.product.toCartModel(),
//                                       inCart: snapshot.data!,
//                                     ));
//                               },
//                             );
//                           }
//                         }
//                         return IconButton(
//                           icon: const Icon(
//                             Icons.shopping_cart,
//                             color: Colors.amber,
//                           ),
//                           onPressed: () async {
//                             print("product price ${widget.product.price}");
//                             await Get.bottomSheet(CartBottomsheet(
//                                 cartModel: widget.product.toCartModel()));
//                           },
//                         );
//                       });
//                 })
//           ],
//         ),
//       );
// }

class ProductItem extends StatelessWidget {
  Product product;
  bool loading;
  ProductItem({super.key, required this.product, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      child: GestureDetector(
        onTap: () {
          if (!loading) {
            Get.to(
              () => ProductScreen(
                product: product,
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: Colors.black.withOpacity(.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Skeleton.leaf(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.18,
                    minHeight: MediaQuery.sizeOf(context).height * 0.14,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: CachedNetworkImage(
                            imageUrl: '$IMAGES_ENDPOINT${product.imagePath}',
                            fit: BoxFit.fill,
                          )),
                      Positioned(
                        top: 7,
                        right: 7,
                        child: Visibility(
                          visible: product.discount != '0',
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 9),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.redAccent),
                            child: Text(
                              "- ${product.discount} ${product.discountType == 'fixed' ? 'DA'.tr : '%'}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "الكمية " + product.description.trim().split("كمية").last,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                    Visibility(
                      visible: product.discount != '0',
                      child: Text(
                          product.discount != '0'
                              ? '${product.realprice} ${'DZA'.tr}'
                              : '',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationColor:
                                Colors.red, // Optional: color of the line
                            decorationThickness:
                                2.0, // Optional: thickness of the line
                          )),
                    ),
                    Text(
                      "${product.price} ${'DZA'.tr}",
                      style: TextStyle(
                          color: product.discount == '0'
                              ? Colors.black87
                              : Colors.redAccent,
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        product.newer == 1
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: MAIN_COLOR,
                                ),
                                child: Text(
                                  'Nouveau'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        GetBuilder<CartController>(
                            tag: "cart",
                            builder: (controller) {
                              return FutureBuilder<bool>(
                                  future: controller.isInCart(product.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.data!) {
                                        return IconButton(
                                          icon: const Icon(
                                            Icons.shopping_cart,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            Get.bottomSheet(
                                                backgroundColor: Colors.white,
                                                enableDrag: true,
                                                CartBottomsheet(
                                                  cartModel:
                                                      product.toCartModel(),
                                                  inCart: snapshot.data!,
                                                ));
                                          },
                                        );
                                      }
                                    }
                                    return IconButton(
                                      icon: const Icon(
                                        Icons.shopping_cart,
                                        color: MAIN_COLOR,
                                      ),
                                      onPressed: () async {
                                        await Get.bottomSheet(CartBottomsheet(
                                            cartModel: product.toCartModel()));
                                      },
                                    );
                                  });
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
