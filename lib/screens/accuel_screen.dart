import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/controllers/index_controller.dart';
import 'package:multi_vendor/controllers/msetting_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/screens/fornisseur_screen.dart';
import 'package:multi_vendor/screens/pages/cart_screen.dart';
import 'package:multi_vendor/screens/pages/home_screen.dart';
import 'package:multi_vendor/screens/search_screen.dart';
import 'package:multi_vendor/services/call_service.dart';
import 'package:multi_vendor/widgets/drawer_widget.dart';
import 'package:multi_vendor/widgets/msetting_dialog.dart';

import 'pages/categories_screen.dart';

class AccuelScreen extends StatelessWidget {
  AccuelScreen({super.key});

  final MSettingController _mSettingController = Get.find(tag: "setting");

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  List<Widget> list1 = [
    const HomeScreen(),
    const CategoriesScreen(),
    SearchScreen(),
    CartScreen(),
  ];

  List<Widget> list2 = [
    const HomeScreen(),
    const CategoriesScreen(),
    SearchScreen(),
    const FornisseurScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Image.asset(
          "assets/top.png",
          width: 100,
        ),
        centerTitle: true,
        leading: true
            ? DrawerButton(onPressed: () {
                _key.currentState?.openDrawer();
              })
            : GestureDetector(
                onTap: () {
                  _key.currentState?.openDrawer();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 35,
                  width: 35,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => MsettingDialog());
              },
              icon: Icon(Icons.description_outlined))

          // Padding(
          //   padding: const EdgeInsets.only(right: 10.0, left: 10),
          //   child: FutureBuilder<String>(
          //       future: CallService().getNumber(),
          //       builder: (context, snapshot) {
          //         if (snapshot.connectionState == ConnectionState.done) {
          //           return ElevatedButton(
          //             onPressed: () {
          //               EasyLauncher.call(number: snapshot.data ?? '');
          //             },
          //             style: ElevatedButton.styleFrom(
          //                 backgroundColor: Colors.amber,
          //                 foregroundColor: Colors.white),
          //             child: Text("Contacter nous".tr),
          //           );
          //         }
          //         return ElevatedButton(
          //           onPressed: () {},
          //           style: ElevatedButton.styleFrom(
          //               backgroundColor: Colors.amber,
          //               foregroundColor: Colors.white),
          //           child: Text("Contacter nous".tr),
          //         );
          //       }),
          // )
        ],
      ),
      body: GetBuilder<MSettingController>(
          tag: "setting",
          builder: (setting) {
            return GetBuilder<IndexController>(
                tag: "index",
                builder: (controller) {
                  return IndexedStack(
                    index: controller.currentIndex,
                    children: setting.isGrossist ? list2 : list1,
                  );
                });
          }),
      bottomNavigationBar: GetBuilder<MSettingController>(
          tag: "setting",
          builder: (setting) {
            return GetBuilder<IndexController>(
                tag: "index",
                builder: (controller) {
                  return BottomNavigationBar(
                      onTap: (value) => controller.changeIndex(value),
                      currentIndex: controller.currentIndex,
                      selectedIconTheme: const IconThemeData(color: MAIN_COLOR),
                      selectedItemColor: MAIN_COLOR,
                      unselectedLabelStyle:
                          const TextStyle(color: Colors.black),
                      type: BottomNavigationBarType.fixed,
                      items: !(setting.isGrossist)
                          ? [
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.home),
                                  label: "Home".tr),
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.dashboard),
                                  label: "Categorie".tr),
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.search),
                                  label: "Search".tr),
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.shopping_cart),
                                  label: "Cart".tr),
                            ]
                          : [
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.home),
                                  label: "Home".tr),
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.dashboard),
                                  label: "Categorie".tr),
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.search),
                                  label: "Search".tr),
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.group),
                                  label: "Fornisseurs".tr),
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.shopping_cart),
                                  label: "Cart".tr),
                            ]);
                });
          }),
    );
  }
}
