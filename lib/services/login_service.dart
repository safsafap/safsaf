import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
//import 'package:get_storage/get_storage.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/user_model.dart';

class LoginService {
  //final _box = GetStorage();
  final _dio = Dio();
  final GetStorage _storage = GetStorage(); // Initialize GetStorage
  final String _cartKey = 'userBox'; // Define a key for cart storage

  Future<bool> deleteAccount(
      {required int id, required String password}) async {
    bool remove = false;
    try {
      final response = await _dio.get(REMOVE_ACCOUNT,
          data: {"id": id, "password": password},
          options: Options(headers: {"Authorization": TOKEN}));

      remove = !(response.statusCode == 404 ||
          response.data.toString().contains("<!doctype html>"));
    } catch (e) {
      remove = false;
      print("showError true");
    }
    return remove;
  }

  Future<User?> login(
      {required String number, required String password}) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      final response = (await _dio.post(LOGIN_ENDPOINT,
          options: Options(headers: {'Authorization': TOKEN}),
          data: {
            "phone_number": number,
            "password": password,
            "token": token
          }));
      if (response.statusCode == 200) {
        // Get the current cart data or initialize an empty map
        final Map<String, dynamic> cartData = _storage.read(_cartKey) ?? {};

        // Add/update the item by its unique ID
        cartData['user'] = response.data;

        // Save the updated cart back to storage
        await _storage.write(_cartKey, cartData);

        return User.fromJson(response.data);
      } else {
        Get.defaultDialog(
            title: "Error", content: Text(response.data["message"]));
      }
    } catch (e) {}
  }

  Future<bool> isLogin() async {
    // return await _box.read("user");

    return true;
  }

  Future<User?> getLogin() async {
    try {
      // Read the current cart data
      final Map<String, dynamic>? cartData = _storage.read(_cartKey);

      if (cartData != null && cartData.containsKey('user')) {
        final item = cartData['user'];
        return User.fromJson(Map<String, dynamic>.from(item));
      }
    } catch (e) {}

    return null;
  }

  Future<void> Logout() async {
    // Get the current cart data

    try {
      final Map<String, dynamic> cartData = _storage.read(_cartKey) ?? {};

      // Remove the item by its ID
      cartData['user'] = null;
      cartData.remove('user');

      // Save the updated cart back to storage
      await _storage.write(_cartKey, cartData);
    } catch (e) {}
  }
}
