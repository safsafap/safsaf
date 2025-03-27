import 'package:connection_notifier/connection_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:multi_vendor/controllers/account_controller.dart';
import 'package:multi_vendor/controllers/cart_controller.dart';
import 'package:multi_vendor/controllers/index_controller.dart';
import 'package:multi_vendor/controllers/location_controller.dart';
import 'package:multi_vendor/controllers/msetting_controller.dart' as s;
import 'package:multi_vendor/firebase_options.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/screens/accuel_screen.dart';
import 'package:multi_vendor/screens/location_picker.dart';
import 'package:multi_vendor/screens/no_internet_screen.dart';
import 'package:multi_vendor/screens/orders_screen.dart';
import 'package:multi_vendor/screens/pages/home_screen.dart';
//import 'package:get_storage/get_storage.dart';
import 'package:multi_vendor/screens/login_screen.dart';
import 'package:multi_vendor/screens/pages/profile_screen.dart';
import 'package:multi_vendor/screens/reset_password_screen.dart';
import 'package:multi_vendor/screens/signup_screen.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/services/change_language.dart';
import 'package:multi_vendor/translator/app-translations.dart';

void main() async {
  //await GetStorage.init("vendor");
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(s.MSettingController(), tag: "setting");
    Get.put(AccountController(), tag: "account");
    Get.put(CartController(), tag: "cart");
    Get.put(IndexController(), tag: "index");
    Get.put(LocationController(), tag: "location");
    
    return GetMaterialApp(
      title: 'Safsaf',
      defaultTransition: Transition.cupertino,
      translations: AppTranslations(),
      locale: ChangeLanguage().initLanguage(),
      getPages: [
        GetPage(name: "/signup_screen", page: () => const SignupScreen()),
        GetPage(name: "/login_screen", page: () => const LoginScreen()),
        GetPage(name: "/home_screen", page: () => const HomeScreen()),
        GetPage(name: "/accuel_screen", page: () => AccuelScreen()),
        GetPage(name: "/location_screen", page: () => LocationPicker()),
        GetPage(name: "/reset_screen", page: () => ResetPasswordScreen()),
        GetPage(name: "/order_screen", page: () => OrdersScreen()),
        GetPage(name: "/profile_screen", page: () => const ProfileScreen()),
      ],
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3
        colorScheme: ColorScheme.fromSeed(
          seedColor: MAIN_COLOR, // Customize the seed color
          brightness: Brightness.light, // Light theme
        ),
        appBarTheme:const AppBarTheme(
          scrolledUnderElevation: 100,
          surfaceTintColor: MAIN_COLOR,
          backgroundColor: Colors.white,
        ),
      ),
      home: ConnectionNotifierToggler(
          
          loading: AccuelScreen(),
          disconnected: const NoInternetScreen(),
          connected: AccuelScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}
