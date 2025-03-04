import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/controllers/account_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/user_model.dart';
import 'package:multi_vendor/screens/web_viewer_screen.dart';
import 'package:multi_vendor/services/call_service.dart';
import 'package:multi_vendor/widgets/language_dialog.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      tag: "account",
      builder: (controller) => Drawer(
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width / 1.4,
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(top: 90, bottom: 13),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/icon.jpeg"),
                      fit: BoxFit.contain)),
            ),
            Text(
              !controller.isLogin
                  ? "Guest".tr
                  : controller.user?.name ?? "unknown",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 30,
            ),
            Visibility(
              visible: !controller.isLogin,
              child: _DrawerItem(
                  title: "Login".tr,
                  icon: Icons.login,
                  indexDrawer: 0,
                  trailing: false,
                  onClick: () {
                    Get.toNamed("/login_screen");
                  }),
            ),
            Visibility(
              visible: controller.isLogin,
              child: _DrawerItem(
                  title: "Profile".tr,
                  icon: Icons.person,
                  indexDrawer: 0,
                  trailing: true,
                  onClick: () {
                    Get.toNamed("/profile_screen");
                  }),
            ),
            Visibility(
              visible: controller.isLogin,
              child: _DrawerItem(
                title: "Commandes".tr,
                icon: Icons.shopping_bag,
                indexDrawer: 1,
                onClick: () {
                  Get.toNamed('/order_screen');
                },
              ),
            ),
            _DrawerItem(
                title: "Changer de langue".tr,
                icon: Icons.language,
                indexDrawer: 2,
                onClick: () {
                  Get.dialog(LanguageDialog());
                }),

                FutureBuilder<String>(
                future: CallService().getNumber(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return _DrawerItem(title:  "Contacter nous".tr, icon: Icons.call, indexDrawer: 0, onClick:  () {
                        EasyLauncher.call(number: snapshot.data ?? '');
                      });
                  }
                  return _DrawerItem(title: "Contacter nous".tr, icon: Icons.call, indexDrawer: 0, onClick: (){
                    
                  });
                }),
            // _DrawerItem(
            //     title: "Politique de confidentialite".tr,
            //     icon: Icons.local_police,
            //     indexDrawer: 2,
            //     onClick: () {
            //       Get.to(WebViewerScreen(
            //           link: "https://safsaftam.com/privacy-policy-app",
            //           title: "Politique de confidentialite".tr));
            //     }),
            // _DrawerItem(
            //     title: "Termes et conditions".tr,
            //     icon: Icons.description,
            //     indexDrawer: 2,
            //     onClick: () {
            //       Get.to(WebViewerScreen(
            //           link: "https://safsaftam.com/terms-of-conditions-app",
            //           title: "Termes et conditions".tr));
            //     }),
            Visibility(
              visible: false,
              child: _DrawerItem(
                  title: "Supprime de compte".tr,
                  icon: Icons.delete_forever,
                  indexDrawer: 2,
                  onClick: () {}),
            ),
            Visibility(
              visible: controller.isLogin,
              child: _DrawerItem(
                  title: "Logout".tr,
                  icon: Icons.logout,
                  indexDrawer: 3,
                  trailing: false,
                  onClick: () {
                    controller.Logout();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _DrawerItem(
      {required String title,
      required IconData icon,
      required int indexDrawer,
      required VoidCallback onClick,
      bool trailing = true}) {
    return Container(
      color: null,
      child: ListTile(
        onTap: () {
          Get.back();
          onClick();
        },
        leading: Icon(
          icon,
          color: title == "Supprime de compte".tr
              ? Colors.redAccent
              : MAIN_COLOR,
        ),
        trailing: trailing ? const Icon(Icons.keyboard_arrow_right) : null,
        title: Text(title),
      ),
    );
  }
}
