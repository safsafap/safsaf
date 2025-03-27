import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/services/cache_service.dart';
import 'package:multi_vendor/widgets/msetting_dialog.dart';

class MSettingController extends GetxController {
  bool isGrossist = true,change = false;
  final _cacheService = CacheService();
  ValueNotifier<bool> isGrossistNotifier = ValueNotifier(true);

  @override
  void onInit() {
    getSettings();
    super.onInit();
  }

  Future<void> getSettings() async {
    bool? i = await _cacheService.getSettings();
    if (i != null) {
      change = true;
      isGrossist = i;
      isGrossistNotifier.value = isGrossist;
      update();
    } else {

      Get.dialog(
          barrierDismissible: false,
          MsettingDialog(
            force: true,
      ));
    }
  }

  Future<void> setGrossist(bool isGrossist) async {
    bool? i = await _cacheService.getSettings();
    if (isGrossist != i) {
    change = true;
    this.isGrossist = isGrossist;
    isGrossistNotifier.value = isGrossist;
    await _cacheService.setGrossist(isGrossist);
    update();
    }
    
  }
}
