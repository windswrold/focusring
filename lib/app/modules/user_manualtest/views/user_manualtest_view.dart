import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gif/gif.dart';

import '../../../../public.dart';
import '../controllers/user_manualtest_controller.dart';

class UserManualtestView extends GetView<UserManualtestController> {
  const UserManualtestView({Key? key}) : super(key: key);

  Widget _buildRadialTextAnnotation() {
    return Obx(() {
      return controller.kState.value == KStateType.idle
          ? Center(
              child: Container(
                width: 308,
                height: 308,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Gif(
                        controller: controller.gifController,
                        image: const AssetImage(
                          "${assetsImages}icons/beging_animation.gif",
                        ),
                        width: 308.w,
                        height: 308.w,
                        autostart: Autostart.loop,
                      ),
                    ),
                    Visibility(
                      visible: controller.kState.value == KStateType.loading,
                      child: Text(
                        controller.countDownNum.value.toString(),
                        style: Get.textTheme.headlineMedium,
                      ),
                    ),
                    Visibility(
                      visible: controller.kState.value == KStateType.success,
                      child: NextButton(
                        onPressed: () {
                          controller.resumeAnimation();
                        },
                        width: 48.w,
                        height: 56.w,
                        bgImg: assetsImages + "icons/icon_start@3x.png",
                        title: "",
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: controller.kState.value == KStateType.loading,
                  child: Text(
                    "begining_test".tr,
                    style: Get.textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: controller.kState.value == KStateType.loading,
                  child: Container(
                    margin: EdgeInsets.only(top: 15.w),
                    child: Text(
                      "manualtest_tip".tr,
                      style: Get.textTheme.displayLarge,
                    ),
                  ),
                ),
              ],
            );
    });
  }

  Widget _buildHeaderrateResult() {
    return Obx(
      (() => Visibility(
          visible: controller.kState.value == KStateType.success,
          child: Container(
            margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 25.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: ColorUtils.fromHex("#FF000000"),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    LoadAssetsImage(
                      controller.type.value == KHealthDataType.BLOOD_OXYGEN
                          ? "icons/status_card_icon_sao2"
                          : "icons/status_card_icon_hr",
                      width: 24,
                      height: 24,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 12.w),
                        child: Text(
                          controller.type.value == KHealthDataType.HEART_RATE
                              ? "current_heartrate".tr
                              : "current_bloodoxygen".tr,
                          style: Get.textTheme.displayLarge,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  height: 32.w,
                  width: 325.w,
                  margin: EdgeInsets.only(top: 25.w),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: ColorUtils.fromHex("#FF00CE3A"),
                              height: 32.w,
                              alignment: Alignment.center,
                              child: Text(
                                "-",
                                style: Get.textTheme.displayLarge,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              color: ColorUtils.fromHex("#FF1DBAFF"),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: ColorUtils.fromHex("#FFFF0000"),
                            ),
                          ),
                        ],
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12.w),
                  child: Text(
                    controller.type.value == KHealthDataType.BLOOD_OXYGEN
                        ? "bloodoxygen_result".tr
                        : "heartrate_result".tr,
                    style: Get.textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = Get.arguments as KHealthDataType;
    return KBasePageView(
      titleStr: type == KHealthDataType.HEART_RATE
          ? "heartrate_measurement".tr
          : type == KHealthDataType.BLOOD_OXYGEN
              ? "bloodoxygen_measurement".tr
              : "test".tr,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildRadialTextAnnotation(),
            _buildHeaderrateResult(),
          ],
        ),
      ),
    );
  }
}
