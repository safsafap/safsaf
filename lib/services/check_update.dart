import 'dart:io';
import 'dart:isolate';

import 'package:app_version_compare/app_version_compare.dart';
import 'package:dio/dio.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CheckUpdate {
  final dio = Dio();

  Future<void> checkUpdate() async {
    try {
      final response = await dio.get(
        UPDATE,
        options: Options(headers: {"Authorization": TOKEN}),
      );

      final localVersion = await getAppVersion();
      final data = response.data;

      // Extract data from the API response
      final minVersion = AppVersion.fromString(data['min_version']);
      final remoteVersion = AppVersion.fromString(data['version']);
      final force = data['force'];
      final maintenance = data['maintenance'];
      final iosLink = data['link_ios'];
      final androidLink = data['link'];

      // Handle maintenance mode
      if (maintenance == 1) {
        _showMaintenanceDialog();
        return;
      }

      // Handle forced or optional updates
      if (force == 1) {
        _handleForcedUpdate(localVersion, remoteVersion, iosLink, androidLink);
      } else {
        _handleOptionalUpdate(
            localVersion, minVersion, remoteVersion, iosLink, androidLink);
      }
    } catch (e) {
      _handleUpdateError(e);
    }
  }

  void _showMaintenanceDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text('maintenance_title'.tr),
          content: Text('maintenance_message'.tr),
          actions: [
            TextButton(
              onPressed: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop(); // Closes the app on Android
                } else if (Platform.isIOS) {
                  exit(0); // Closes the app on iOS (not recommended)
                }
              },
              child: Text('ok'.tr),
            ),
          ],
        ),
      ),
      barrierDismissible: false, // Prevent dialog dismissal
    );
  }

  void _handleForcedUpdate(
      AppVersion local, AppVersion remote, String iosLink, String androidLink) {
    if (local < remote) {
      Get.dialog(
        PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text('force_update_title'.tr),
            content: Text('force_update_message'.tr),
            actions: [
              TextButton(
                onPressed: () => _launchAppStore(iosLink, androidLink),
                child: Text('update_now'.tr),
              ),
            ],
          ),
        ),
        barrierDismissible: false, // Prevent dialog dismissal
      );
    }
  }

  void _handleOptionalUpdate(AppVersion local, AppVersion minVersion,
      AppVersion version, String iosLink, String androidLink) {
    if (local >= minVersion) {
      // Get.dialog(
      //   AlertDialog(
      //     title: Text('optional_update_title'.tr),
      //     content: Text('optional_update_message'.tr),
      //     actions: [
      //       TextButton(
      //         onPressed: () => _launchAppStore(iosLink, androidLink),
      //         child: Text('update'.tr),
      //       ),
      //       TextButton(
      //         onPressed: () {
      //           Get.back();
      //           Get.back();
      //         },
      //         child: Text('later'.tr),
      //       ),
      //     ],
      //   ),
      //   barrierDismissible: true, // Prevent dialog dismissal
      // );
    } else {
      _handleForcedUpdate(local, minVersion, iosLink, androidLink);
    }
  }

  void _handleUpdateError(dynamic error) {
    // Get.snackbar(
    //   'error'.tr,
    //   'update_check_failed'.tr,
    //   backgroundColor: Colors.red,
    //   colorText: Colors.white,
    // );
  }

  Future<void> _launchAppStore(String iosLink, String androidLink) async {
    final storeUrl = GetPlatform.isIOS ? iosLink : androidLink;

    await EasyLauncher.url(url: storeUrl);
  }

  Future<AppVersion> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    final appCurrentVersion = AppVersion.fromString(version);

    return appCurrentVersion; // Or just 'version' if you don't need build number
  }
}
