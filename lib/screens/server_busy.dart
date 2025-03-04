import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';

class ServerBusyScreen extends StatelessWidget {
  const ServerBusyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off, // Cloud off icon to indicate server issue
                size: 100,
                color: MAIN_COLOR, // Orange color for the icon
              ),
              const SizedBox(height: 20),
              Text(
                'messageserver'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: MAIN_COLOR,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MAIN_COLOR),
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop(); // Closes the app on Android
                    } else if (Platform.isIOS) {
                      exit(0); // Closes the app on iOS (not recommended)
                    }
                  },
                  child: Text(
                    'close'.tr,
                    style: const TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
