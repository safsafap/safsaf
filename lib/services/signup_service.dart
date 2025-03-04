import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/signup_model.dart';

class SignupService {
  final _dio = Dio();

  Future<void> Signup(SignupModel user) async {
    try {

      await _dio.post(SIGNUP_ENDPOINT,
          data: user.toJSon(),
          options: Options(headers: {'Authorization': TOKEN}));
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: 'Signup success',
        title: "Success",
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: e.toString(),
        title: "error",
        backgroundColor: Colors.redAccent,
      ));
    }
  }
}
