import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:multi_vendor/controllers/location_controller.dart';

class LocationPicker extends StatelessWidget {
  LocationPicker({super.key});

  final LocationController _locationController = Get.find(tag: "location");

  Future<LatLong> getCurrentLocation() async {
    try {
      if (!_locationController.isInitallised) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 5));
        return LatLong(position.latitude, position.longitude);
      } else {
        return LatLong(_locationController.lat, _locationController.lng);
      }
    } catch (e) {}
    return const LatLong(28.0268755, 1.6528399999999976);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: FutureBuilder<LatLong>(
      future: getCurrentLocation(),
      builder: (BuildContext context, AsyncSnapshot<LatLong> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          if (snapshot.data == null) {
          } else {}
          return FlutterLocationPicker(
              onError: (e) {},
              mapAnimationDuration: const Duration(milliseconds: 300),
              selectLocationButtonHeight: 50,
              locationButtonBackgroundColor: Colors.green.withOpacity(.5),
              zoomButtonsBackgroundColor: Colors.green.withOpacity(.5),
              selectLocationButtonLeadingIcon: const Icon(
                Icons.check,
                color: Colors.white,
                size: 25,
              ),
              markerIcon: const Icon(
                Icons.location_on,
                color: Colors.redAccent,
                size: 50,
              ),
              selectLocationButtonText: "Select Location".tr,
              selectedLocationButtonTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
              selectLocationButtonStyle: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.green.withOpacity(.7)),
              ),
              initZoom: 11,
              minZoomLevel: 5,
              maxZoomLevel: 16,
              initPosition: snapshot.data!,
              onPicked: (pickedData) {
               
                _locationController.pickLocation(
                    lati: pickedData.latLong.latitude,
                    lngi: pickedData.latLong.longitude);
                Get.back();
              });
        }
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.green,
        ));
      },
    ));
  }
}
