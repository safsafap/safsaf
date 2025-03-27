import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChangeLanguage {
  late Locale locale;
  final GetStorage _storage = GetStorage(); // Initialize GetStorage
  final String _cartKey = 'lang'; // Define a key for cart storage

  Future<void> changeLanguage(
      {required String lang}) async {
    Locale locale = Locale(lang);
    Get.updateLocale(locale);
    final Map<String, dynamic> cartData = _storage.read(_cartKey) ?? {};

    // Add/update the item by its unique ID
    cartData['lang'] = lang;
    // Save the updated cart back to storage
    await _storage.write(_cartKey, cartData);
  }

  Locale initLanguage(){
    Map<String, dynamic> lang = getLanguage();
  
    Locale locale = Locale(lang['lang']);

    return locale;
     
  }

  Map<String, dynamic> getLanguage() {
    final Map<String, dynamic> cartData = _storage.read(_cartKey) ??
        {
          'lang': 'ar',
          
        };

    return cartData;
  }
}
