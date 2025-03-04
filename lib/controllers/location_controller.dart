import 'package:get/get.dart';

class LocationController extends GetxController {
  double lat = 0, lng = 0;
  bool isInitallised = false;

  void pickLocation({required double lati, required double lngi}) {
    lat = lati;
    lng = lngi;
    isInitallised = true;
    update();
  }
}
