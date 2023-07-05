import 'package:flutter/material.dart';
import 'package:focusring/public.dart';
import 'package:focusring/views/water_wave.dart';

import 'package:get/get.dart';
import '../controllers/find_devices_controller.dart';

class FindDevicesView extends GetView<FindDevicesController> {
  const FindDevicesView({Key? key}) : super(key: key);

  Widget _buildListItem() {
    return Container(
      height: 78.w,
      margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          LoadAssetsImage(
            "icons/device_43",
            width: 43,
            height: 43,
          ),
          18.rowWidget,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "data",
                style: Get.textTheme.bodyLarge,
              ),
              4.columnWidget,
              Text(
                "data",
                style: Get.textTheme.bodyMedium,
              ),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          LoadAssetsImage(
            "icons/arrow_right_small",
            width: 7,
            height: 12,
          ),
        ],
      ),
    );
  }

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
          Container(
            margin: EdgeInsets.only(left: 6, right: 6, top: 25.w),
            child: Text(
              "search_devices".tr,
              style: Get.textTheme.bodyLarge,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 6, right: 6, top: 9, bottom: 25.w),
            child: Text(
              "search_devicestip".tr,
              textAlign: TextAlign.center,
              style: Get.textTheme.labelMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return _buildListItem();
              },
            ),
          )
        ],
      ),
    );
  }
}
