import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/order_after_model.dart';
import 'package:multi_vendor/screens/pdf_screen.dart';

class OrderWidget extends StatelessWidget {
  OrderAfterModel order;
  OrderWidget({super.key, required this.order});

  Color getColor() {
    Color color = Colors.green;
    if (order.status == 'en cour') {
      color = MAIN_COLOR;
    } else if (order.status == 'annulé') {
      color = Colors.redAccent;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: getColor()),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                offset: const Offset(0, 3))
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CommmandeID'.tr + order.order_id.replaceAll('CommandeID:', ''),
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                order.status.tr,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: getColor()),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total".tr,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              Text(
                "${order.total} DZD",
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () {
              Get.to(() => PdfScreen(path: order.image));
            },
            trailing: const Icon(Icons.keyboard_arrow_right),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                BootstrapIcons.filetype_pdf,
                size: 48,
                color: MAIN_COLOR,
              ),
            ),
            title: Text("facture pdf".tr),
            subtitle: Text("click to voir information".tr),
          )
        ],
      ),
    );
  }
}
