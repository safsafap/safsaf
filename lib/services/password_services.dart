import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';

class PasswordServices {
  final _dio = Dio();

  Future<void> update(
      {required String number, required String password}) async {
    try {
      await _dio.post(PASSWORD_RESET,
          data: {'phone_number': number, 'new_password': password},
          options: Options(
            receiveTimeout: Duration(seconds: 3),
            headers: {'Authorization': TOKEN},
          ));
      Get.back();
      Get.back();
      Get.showSnackbar(const GetSnackBar(
        backgroundColor: Colors.green,
        title: 'Success',
        message: 'Password update success',
      ));
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.green,
        title: 'Error',
        message: 'Password update error : $e',
      ));
    }
  }
}
