import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/controllers/location_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/signup_model.dart';
import 'package:multi_vendor/services/signup_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _path = "";
  bool _isLoading = false, seller = false, picked = false;
  LocationController _locationController = Get.find(tag: 'location');

  TextEditingController cpassController = TextEditingController(),
      passwordController = TextEditingController(),
      numberController = TextEditingController(),
      fullnameController = TextEditingController();

  _SignupUsers() async {
    if (_formkey.currentState!.validate() &&
        _locationController.isInitallised &&
        picked) {
      setState(() {
        _isLoading = true;
      });

      await SignupService().Signup(SignupModel(
          password: passwordController.text,
          name: fullnameController.text,
          phoneNumber: int.parse(numberController.text.toString().substring(1)),
          lat: _locationController.lat.toString(),
          lng: _locationController.lng.toString()));

      setState(() {
        _isLoading = false;
      });
    }
  }

  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "Signup !".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text("create your new acccount et joindre nous".tr),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: fullnameController,
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return 'Fullname must be at least 3 characters long'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Fullname'.tr,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: numberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.length != 10) {
                      return 'Number must be 10 characters'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Number'.tr,
                    prefixIcon: const Icon(Icons.call),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  onTap: () {
                    setState(() {
                      picked = true;
                    });
                    Get.toNamed('location_screen');
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Choisir votre localisation".tr,
                    prefixIcon: Icon(Icons.location_on),
                    suffixIcon: const Icon(Icons.edit),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: obsecure,
                  validator: (value) {
                    if (value == null || value.length < 7) {
                      return 'Password must be at least 8 characters long'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(
                            obsecure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obsecure = !obsecure;
                          });
                        }),
                    hintText: 'Password'.tr,
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: cpassController,
                  obscureText: obsecure,
                  validator: (value) {
                    if (value! != passwordController.text) {
                      return "Confirm password cannot be empty".tr;
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(
                            obsecure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obsecure = !obsecure;
                          });
                        }),
                    hintText: 'Confirme password'.tr,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Visibility(
                  visible: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Buyer'),
                      Radio(
                        activeColor: Colors.green,
                        value: false,
                        groupValue: seller,
                        onChanged: (value) => setState(() {
                          seller = value ?? true;
                        }),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text('Seller'),
                      Radio(
                        activeColor: Colors.green,
                        value: true,
                        groupValue: seller,
                        onChanged: (value) => setState(() {
                          seller = value ?? false;
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    _SignupUsers();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 53,
                    decoration: BoxDecoration(
                      color: MAIN_COLOR,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'create account'.tr,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(),
                const SizedBox(height: 10),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: MAIN_COLOR),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize:
                            Size(MediaQuery.sizeOf(context).width * .9, 50)),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Login'.tr,
                      style: TextStyle(
                          fontSize: 18,
                          color: MAIN_COLOR,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
