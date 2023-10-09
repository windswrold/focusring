import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../public.dart';
import '../controllers/automatic_settings_controller.dart';

class AutomaticSettingsView extends GetView<AutomaticSettingsController> {
  const AutomaticSettingsView({Key? key}) : super(key: key);

  Widget _getAutomaticSetting({
    required String title,
    required RxBool value,
    required String subTitle,
    required RxString subValue,
    required String symbol,
    required Function(bool a) onChanged,
    required VoidCallback onSubChange,
    required String startTimeTitle,
    required RxString startTimeValue,
    required String endTimeTitle,
    required RxString endTimeValue,
    required VoidCallback startTimeChange,
    required VoidCallback endTimeChange,
  }) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Container(
              height: 44.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Get.textTheme.displayLarge,
                  ),
                  Obx(
                    () => Switch(
                      value: value.value,
                      onChanged: onChanged,
                      activeColor: Colors.white,
                      activeTrackColor: ColorUtils.fromHex("#FF05E6E7"),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: startTimeChange,
              child: Container(
                height: 44.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      startTimeTitle,
                      style: Get.textTheme.displayLarge,
                    ),
                    Row(
                      children: [
                        Obx(
                          () => Text(
                            startTimeValue.value.toString(),
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
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: endTimeChange,
              child: Container(
                height: 44.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      endTimeTitle,
                      style: Get.textTheme.displayLarge,
                    ),
                    Row(
                      children: [
                        Obx(
                          () => Text(
                            endTimeValue.value.toString(),
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
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: onSubChange,
              child: Container(
                height: 44.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subTitle,
                      style: Get.textTheme.displayLarge,
                    ),
                    Row(
                      children: [
                        Obx(
                          () => Text(
                            subValue.value.toString() + symbol,
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "automatic_settings".tr,
      actions: [
        TextButton(
          onPressed: () {
            controller.save();
          },
          child: Text(
            "save".tr,
            style: Get.textTheme.labelMedium,
          ),
        ),
      ],
      body: Column(
        children: [
          Container(
            height: 39.w,
            margin: EdgeInsets.only(left: 28.w),
            color: Get.theme.backgroundColor,
            alignment: Alignment.centerLeft,
            child: Text(
              "heartrate_measurement".tr,
              style: Get.textTheme.bodyMedium,
            ),
          ),
          _getAutomaticSetting(
              title: "automatic_measuring".tr,
              value: controller.heartRateAutoTestSwitch,
              onChanged: (a) {
                controller.onChangeHeart(a);
              },
              onSubChange: () {
                controller.showHeartrate_Offset();
              },
              subTitle: 'heartrate_interval'.tr,
              subValue: controller.heartRateAutoTestInterval,
              startTimeTitle: "starttime".tr,
              endTimeTitle: "endtime".tr,
              startTimeValue: controller.startTimeHeart,
              endTimeValue: controller.endTimeHeart,
              startTimeChange: () {
                controller.onChangeTime(0);
              },
              endTimeChange: () {
                controller.onChangeTime(1);
              },
              symbol: "  min"),
          Container(
            height: 39.w,
            margin: EdgeInsets.only(left: 28.w),
            color: Get.theme.backgroundColor,
            alignment: Alignment.centerLeft,
            child: Text(
              "bloodoxygen_measurement".tr,
              style: Get.textTheme.bodyMedium,
            ),
          ),
          _getAutomaticSetting(
            title: "automatic_measuring".tr,
            value: controller.bloodOxygenAutoTestSwitch,
            onChanged: (a) {
              controller.onChangeBloodoxy(a);
            },
            onSubChange: () {
              controller.showBloodOxygen_Offset();
            },
            subTitle: 'bloodoxygen_interval'.tr,
            subValue: controller.bloodOxygenAutoTestInterval,
            symbol: " min",
            startTimeTitle: "starttime".tr,
            endTimeTitle: "endtime".tr,
            startTimeValue: controller.startTimeOxygen,
            endTimeValue: controller.endTimeOxygen,
            startTimeChange: () {
              controller.onChangeTime(2);
            },
            endTimeChange: () {
              controller.onChangeTime(3);
            },
          ),
        ],
      ),
    );
  }
}
