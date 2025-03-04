import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/screens/confirme_reset.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  TextEditingController _controller = TextEditingController();
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Form(
          key: _globalKey,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  color: MAIN_COLOR,
                  size: 80,
                ),
                Text(
                  "Reset Password".tr,
                  style: TextStyle(
                      color: MAIN_COLOR,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Text('enter your phone number to continue'.tr),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  width: MediaQuery.sizeOf(context).width * .9,
                  child: TextFormField(
                    validator: (value) =>
                        value!.length == 10 ? null : 'enter valide number'.tr,
                    keyboardType: TextInputType.phone,
                    controller: _controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13)),
                        hintText: "Number".tr,
                        prefixIcon: Icon(
                          Icons.call,
                          color: Colors.green,
                        )),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_globalKey.currentState!.validate()) {
                        Get.to(() => ConfirmeReset(phone: _controller.text));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MAIN_COLOR,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        fixedSize:
                            Size(MediaQuery.sizeOf(context).width * .9, 55)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Continue".tr),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.keyboard_arrow_right)
                      ],
                    )),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          )),
    );
  }
}
