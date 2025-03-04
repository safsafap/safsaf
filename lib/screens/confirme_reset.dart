import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/screens/reset_password_screen.dart';
import 'package:multi_vendor/services/password_services.dart';

class ConfirmeReset extends StatefulWidget {
  String phone;
  ConfirmeReset({super.key, required this.phone});

  @override
  State<ConfirmeReset> createState() => _ConfirmeResetState();
}

class _ConfirmeResetState extends State<ConfirmeReset> {
  TextEditingController _controller = TextEditingController();

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Form(
          key: _globalKey,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
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
                  Text('enter your new password to continue'.tr),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.sizeOf(context).width * .9,
                    child: TextFormField(
                      validator: (value) => value!.length >= 8
                          ? null
                          : 'password must at least 8 character'.tr,
                      obscureText: obsecure,
                      controller: _controller,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(obsecure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  obsecure = !obsecure;
                                });
                              }),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13)),
                          hintText: "Password".tr,
                          prefixIcon: Icon(
                            Icons.lock,
                          )),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    width: MediaQuery.sizeOf(context).width * .9,
                    child: TextFormField(
                      obscureText: obsecure,
                      validator: (value) {
                        if (_controller.text == value) {
                          return null;
                        }

                        return 'password not match'.tr;
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(obsecure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  obsecure = !obsecure;
                                });
                              }),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13)),
                          hintText: "Confirme password".tr,
                          prefixIcon: Icon(
                            Icons.lock,
                          )),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_globalKey.currentState!.validate()) {
                          // Navigate back to the previous route (Page 1 or Page 4)
                          await PasswordServices().update(
                              number: widget.phone, password: _controller.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MAIN_COLOR,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          fixedSize:
                              Size(MediaQuery.sizeOf(context).width * .9, 55)),
                      child: Text("Reset".tr)),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
