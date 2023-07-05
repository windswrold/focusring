import 'package:flutter/material.dart';
import 'package:focusring/public.dart';
import 'package:focusring/views/water_wave.dart';

import 'package:get/get.dart';
import '../controllers/find_devices_controller.dart';

class FindDevicesView extends GetView<FindDevicesController> {
  const FindDevicesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "add_device".tr,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 35.w),
              width: 229.w,
              height: 229.w,
              child: KRippleWave(
                color: ColorUtils.fromHex("#FF05E6E7"),
                onCreate: (AnimationController c) {
                  controller.onCreate(c);
                },
                child: LoadAssetsImage(
                  "icons/search_revolve",
                  width: 92,
                  height: 92,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              controller.pauseAnimation();
            },
            icon: Text("data"),
          ),
          IconButton(
            onPressed: () {
              controller.resumeAnimation();
            },
            icon: Text("data"),
          ),
        ],
      ),
    );
  }
}
