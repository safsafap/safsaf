import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multi_vendor/controllers/account_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/signup_model.dart';
import 'package:multi_vendor/models/user_model.dart';
import 'package:multi_vendor/screens/accuel_screen.dart';

class SignupService {
  final _dio = Dio();
  final GetStorage _storage = GetStorage(); // Initialize GetStorage
  final String _cartKey = 'userBox'; // Define a key for cart storage
  AccountController _accountController = Get.find(tag: 'account');

  Future<void> Signup(SignupModel user) async {
    try {
      Map<String, dynamic> d = user.toJSon();
      String? token =await FirebaseMessaging.instance.getToken();
      d['token'] = token;
      final response = await _dio.post(SIGNUP_ENDPOINT,
          data: d,
          options: Options(headers: {'Authorization': TOKEN}));

      final Map<String, dynamic> cartData = _storage.read(_cartKey) ?? {};

      // Add/update the item by its unique ID
      cartData['user'] = response.data;

      // Save the updated cart back to storage
      await _storage.write(_cartKey, cartData);

      User u = User.fromJson(response.data);
      _accountController.user = u;
      _accountController.isLogin = true;

      Get.offAll(() => AccuelScreen());
    } on DioException catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: 'phone number is already used'.tr,
        backgroundColor: Colors.redAccent,
      ));
    }
  }
}
