import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});

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
              Icons.login,
              color: Colors.white,
              size: 45,
            ),
          ),
          Text(
            "Login".tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text("login to complete make your order".tr),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            Get.toNamed('/login_screen');
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: MAIN_COLOR,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Text(
            "Login".tr,
            style: const TextStyle(color: Colors.white),
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
            style: const TextStyle(color: Colors.black54),
          ),
        )
      ],
    );
  }
}
