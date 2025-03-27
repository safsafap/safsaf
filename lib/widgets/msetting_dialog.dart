import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:multi_vendor/controllers/index_controller.dart';

import '../controllers/msetting_controller.dart';

class MsettingDialog extends StatelessWidget {
  bool force = false;
  late ValueNotifier<bool> isGrossist;
  MSettingController settingController = Get.find(tag: "setting");

  MsettingDialog({super.key, this.force = false}){
    isGrossist =ValueNotifier(settingController.isGrossist);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Shopping Setting".tr),
      content: ValueListenableBuilder(
        valueListenable: isGrossist,
        builder: (context, v, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  isGrossist.value = true;
                },
                leading: Radio(
                    value: v,
                    groupValue: true,
                    onChanged: (value) {
                      isGrossist.value = value ?? false;
                    }),
                title: Text("Bulk shopping".tr),
              ),
              ListTile(
                onTap: () {
                  isGrossist.value = false;
                },
                leading: Radio(
                    value: v,
                    groupValue: false,
                    onChanged: (value) {
                      isGrossist.value = value ?? false;
                    }),
                title: Text("Retail shopping".tr),
              ),
            ],
          );
        },
      ),
      actions: [
        Visibility(
          visible: !force,
          child: TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Cancel".tr),
          ),
        ),
        TextButton(
          onPressed: () async {
            Get.back();
                            Get.find<IndexController>(tag: "index").changeIndex(0);

            await Get.find<MSettingController>(tag: "setting")
                .setGrossist(isGrossist.value);
          },
          child: Text("Save".tr),
        ),
      ],
    );
  }
}
