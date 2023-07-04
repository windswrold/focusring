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
    required RxInt subValue,
    required String symbol,
    required Function(bool a) onChanged,
    required VoidCallback onSubChange,
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
              value: controller.heartstate,
              onChanged: (a) {
                controller.onChangeHeart(a);
              },
              onSubChange: () {
                controller.showHeartrate_Offset();
              },
              subTitle: 'heartrate_interval'.tr,
              subValue: controller.heartrate_offset,
              symbol: KHealthDataType.HEART_RATE.getSymbol()),
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
              value: controller.bloodoxygenstate,
              onChanged: (a) {
                controller.onChangeBloodoxy(a);
              },
              onSubChange: () {
                controller.showBloodOxygen_Offset();
              },
              subTitle: 'bloodoxygen_interval'.tr,
              subValue: controller.bloodoxygen_offset,
              symbol: KHealthDataType.BLOOD_OXYGEN.getSymbol(),),
        ],
      ),
    );
  }
}
