import 'package:flutter/material.dart';
import 'package:focusring/public.dart';
import 'package:focusring/utils/custom_toast.dart';

import 'package:get/get.dart';
import '../controllers/device_info_controller.dart';

class DeviceInfoView extends GetView<DeviceInfoController> {
  const DeviceInfoView({Key? key}) : super(key: key);

  Widget _getListItem({
    required int index,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      height: 44.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.tr,
            style: Get.textTheme.displayLarge,
          ),
          20.rowWidget,
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Get.textTheme.headlineLarge,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
        titleStr: "about".tr,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 77.w),
              alignment: Alignment.center,
              child: LoadAssetsImage(
                "icons/device",
                width: 84,
                height: 86,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.w),
              child: Text(
                controller.ringDevice.localName ?? "",
                style: Get.textTheme.bodyLarge,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 38.w),
              decoration: BoxDecoration(
                color: ColorUtils.fromHex("#000000"),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _getListItem(index: 0, title: "current_v".tr, value: "1.0.0"),
                  _getListItem(index: 0, title: "new_v".tr, value: "1.0.0"),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 16.w),
              decoration: BoxDecoration(
                color: ColorUtils.fromHex("#000000"),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _getListItem(
                      index: 0,
                      title: "mac_adds".tr,
                      value: controller.ringDevice.macAddress ?? ""),
                ],
              ),
            ),
            Expanded(child: Container()),
            Obx(
              () => Stack(
                // alignment: Alignment.centerLeft,
                children: [
                  Visibility(
                    visible: controller.buttonState.value == KState.loading,
                    child: Container(
                      height: 44.w,
                      width: controller.progress * 350.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          colors: [
                            ColorUtils.fromHex("#FF0E9FF5"),
                            ColorUtils.fromHex("#FF02FFE2"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  NextButton(
                    onPressed: () {
                      HWToast.showSucText(text: "no_v".tr);
                      // controller.changeButtonState(KState.loading);
                    },
                    height: 44.w,
                    width: 350.w,
                    borderRadius: 22,
                    margin: EdgeInsets.only(bottom: 20.w),
                    border: controller.buttonState.value == KState.loading
                        ? Border.all(color: ColorUtils.fromHex("#FF05E6E7"))
                        : null,
                    gradient: (controller.buttonState.value == KState.idle ||
                            controller.buttonState.value == KState.success)
                        ? LinearGradient(
                            colors: [
                              ColorUtils.fromHex("#FF0E9FF5"),
                              ColorUtils.fromHex("#FF02FFE2"),
                            ],
                          )
                        : null,
                    activeColor: controller.buttonState.value == KState.fail
                        ? ColorUtils.fromHex("#FF4D5461")
                        : null,
                    title: controller.buttonState.value == KState.success
                        ? "upgrade_v".tr
                        : controller.buttonState.value == KState.loading
                            ? "upgradeing_v".tr
                            : "check_v".tr,
                    textStyle: Get.textTheme.displayLarge,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
