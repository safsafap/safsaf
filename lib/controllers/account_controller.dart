import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/models/user_model.dart';
import 'package:multi_vendor/services/login_service.dart';
import 'package:multi_vendor/services/profile_services.dart';

class AccountController extends GetxController {
  User? user;
  bool isLogin = false;
  final _loginService = LoginService();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initialise();
  }

  void initialise() async {
    user = await _loginService.getLogin();
    if (user != null) {
      isLogin = true;
      update();
    } else {}


    var messaging = FirebaseMessaging.instance;
    try {

      await messaging.subscribeToTopic('all');
      await addHandler();
    } catch (e) {}
  }

  Future<void> addHandler() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      firebaseMessagingBackgroundHandler(message);
    });
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Handle the background message
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'news',
            channelName: 'News Channel',
            channelDescription: 'Channel for news notifications',
            defaultColor: Colors.teal,
            ledColor: Colors.teal,
          ),
        ],
      );

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 9,
            channelKey: 'news',
            title: "${message.notification?.title}",
            body: "${message.notification?.body}",
            largeIcon: "${message.notification?.android?.imageUrl}",
            notificationLayout: NotificationLayout.Default),
      );
    }
  }

  Future<void> login({required String number, required String password}) async {
    user = await _loginService.login(number: number, password: password);
    isLogin = user != null;
    if (isLogin) {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.green,
        title: "Success".tr,
        message: "Success Login".tr,
      ));

      update();
    } else {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.redAccent,
        title: "Error".tr,
        message: "Error Login , Email or Password Incorrect".tr,
      ));

    }
  }

  Future<void> Logout({bool remove = false}) async {
    user = null;
    isLogin = false;
    await _loginService.Logout();
    (!remove)? Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.orange,
      title: 'logout'.tr,
      message: 'you are logout'.tr,
    )):Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.orange,
      title: 'your account has been removed'.tr,
    ));
  }

  Future<void> updateProfile() async {
    await ProfileServices().updateProfile(user!);
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.green,
      title: "Success".tr,
      message: "Profile Update Successfull".tr,
    ));
    update();
  }
  
}
