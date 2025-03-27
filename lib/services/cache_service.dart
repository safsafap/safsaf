import 'package:get_storage/get_storage.dart';

class CacheService {

  final GetStorage _storage = GetStorage();
  final String _cartKey = 'isGrossist';

  Future<void> setGrossist(bool isGrossist) async {
    final Map<String, dynamic> cartData = _storage.read(_cartKey) ?? {};

    cartData[_cartKey] = isGrossist;

    print("isGrossist: $isGrossist");

    await _storage.write(_cartKey, cartData);
  }



  Future<bool?> getSettings() async {

    final Map<String, dynamic>? cartData = _storage.read(_cartKey);

   
    if (cartData == null) {
      return null;
    }

    return cartData[_cartKey];
  }

 

}