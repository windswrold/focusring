import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:focusring/app/data/ring_device.dart';
import 'package:focusring/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:focusring/public.dart';
import 'package:focusring/views/water_wave.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../controllers/find_devices_controller.dart';

class FindDevicesView extends GetView<FindDevicesController> {
  const FindDevicesView({Key? key}) : super(key: key);

  Widget _buildListItem(RingDevice item) {
    return InkWell(
      onTap: () {
        controller.onTapItem(item);
      },
      child: Container(
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
                  item.localName ?? "",
                  style: Get.textTheme.bodyLarge,
                ),
                4.columnWidget,
                Text(
                  item.macAddress ?? "",
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "add_device".tr,
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullUp: false,
        onRefresh: () {
          controller.onRefresh();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 25.w),
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
              child: Obx(
                () => ListView.builder(
                    itemCount: controller.scanResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = controller.scanResults[index];
                      return _buildListItem(item);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
