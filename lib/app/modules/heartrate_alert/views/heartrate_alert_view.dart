import 'package:flutter/material.dart';
import 'package:focusring/public.dart';

import 'package:get/get.dart';

import '../controllers/heartrate_alert_controller.dart';

class HeartrateAlertView extends GetView<HeartrateAlertController> {
  const HeartrateAlertView({Key? key}) : super(key: key);


  

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "heartrate_alert".tr,
      body: Column(
        children: [
          Container(
            height: 44.w,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: ColorUtils.fromHex("#FF000000"),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "heartrate_state".tr,
                  style: Get.textTheme.displayLarge,
                ),
                Obx(
                  () => Switch(
                    value: controller.state.value,
                    onChanged: (a) {
                      controller.onChanged(a);
                    },
                    activeColor: Colors.white,
                    activeTrackColor: ColorUtils.fromHex("#FF05E6E7"),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.w),
            decoration: BoxDecoration(
              color: ColorUtils.fromHex("#FF000000"),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    controller.showMax();
                  },
                  child: Container(
                    height: 44.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "max_heartrate".tr,
                          style: Get.textTheme.displayLarge,
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                controller.maxHeartAlert.toString() +
                                    KHealthDataType.HEART_RATE.getSymbol(),
                                style: Get.textTheme.bodyMedium,
                              ),
                            ),
                            12.rowWidget,
                            LoadAssetsImage(
                              "icons/arrow_right_small",
                              width: 7,
                              height: 12,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.showMin();
                  },
                  child: Container(
                    height: 44.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "min_heartrate".tr,
                          style: Get.textTheme.displayLarge,
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                controller.minHeartAlert.toString() +
                                    KHealthDataType.HEART_RATE.getSymbol(),
                                style: Get.textTheme.bodyMedium,
                              ),
                            ),
                            12.rowWidget,
                            LoadAssetsImage(
                              "icons/arrow_right_small",
                              width: 7,
                              height: 12,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
