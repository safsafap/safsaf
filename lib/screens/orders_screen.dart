import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/controllers/account_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/order_after_model.dart';
import 'package:multi_vendor/services/order_services.dart';
import 'package:multi_vendor/widgets/order_widget.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});
  AccountController _accountController = Get.find(tag: 'account');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Orders'.tr),
      ),
      body: FutureBuilder<List<OrderAfterModel>>(
        future: OrderServices().getOrders(_accountController.user?.id ?? 0),
        builder: (BuildContext context,
            AsyncSnapshot<List<OrderAfterModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data?.isEmpty ?? true
                ? Center(
                    child: Text("aucun order".tr),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, position) {
                      return OrderWidget(order: snapshot.data![position]);
                    });
          }
          return const Center(
            child: CircularProgressIndicator(
              color: MAIN_COLOR,
            ),
          );
        },
      ),
    );
  }
}
