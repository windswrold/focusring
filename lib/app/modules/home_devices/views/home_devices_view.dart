import 'package:flutter/material.dart';
import 'package:beering/app/data/ring_device.dart';
import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../public.dart';
import '../controllers/home_devices_controller.dart';

class HomeDevicesView extends GetView<HomeDevicesController> {
  const HomeDevicesView({Key? key}) : super(key: key);

  Widget _getList() {
    Widget _getListItem({
      required int index,
      required String icon,
      required String title,
      String? desc,
    }) {
      return InkWell(
        onTap: () {
          controller.onTapList(index);
        },
        child: Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  LoadAssetsImage(
                    icon,
                    width: 40,
                    height: 40,
                  ),
                  12.rowWidget,
                  Text(
                    title.tr,
                    style: Get.textTheme.displayLarge,
                  ),
                ],
              ),
              Row(
                children: [
                  Visibility(
                    visible: desc != null,
                    child: Text(
                      desc ?? "",
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
      );
    }

    return Container(
      margin: EdgeInsets.only(left: 12.w, top: 12.w, right: 12.w),
      padding: EdgeInsets.only(top: 16.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Obx(
        () => controller.isConnect.value == false
            ? Column(
                children: [
                  _getListItem(
                      index: 2,
                      icon: "icons/device_icon_upgrade",
                      title: "ota_upgrade"),
                  _getListItem(
                      index: 3,
                      icon: "icons/device_icon_reset",
                      title: "restore_settings"),
                ],
              )
            : Column(
                children: [
                  GetBuilder<AppViewController>(
                      tag: AppViewController.tag,
                      id: AppViewController.userinfoID,
                      builder: (a) {
                        return _getListItem(
                          index: 0,
                          icon: "icons/device_icon_hrwarning",
                          title: "heartrate_alert",
                          desc: a.user.value?.heartRateWarnSwitch == true
                              ? "On"
                              : "Off",
                        );
                      }),
                  _getListItem(
                      index: 1,
                      icon: "icons/device_icon_auto",
                      title: "automatic_settings"),
                  _getListItem(
                      index: 2,
                      icon: "icons/device_icon_upgrade",
                      title: "ota_upgrade"),
                  _getListItem(
                      index: 3,
                      icon: "icons/device_icon_reset",
                      title: "restore_settings"),
                ],
              ),
      ),
    );
  }

  Widget _getManual_test() {
    Widget _getManual_item({
      required String bgIcon,
      required String icon,
      required String title,
      required Color bgColor,
      required VoidCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        child: Container(
          padding:
              EdgeInsets.only(left: 11.w, right: 11.w, bottom: 11.w, top: 28.w),
          width: 157.w,
          height: 146.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("$assetsImages$bgIcon@3x.png"),
            ),
          ),
          child: Column(
            children: [
              LoadAssetsImage(
                icon,
                width: 44,
                height: 36,
              ),
              10.columnWidget,
              Text(
                title.tr,
                style: Get.textTheme.displayLarge,
              ),
              // 10.columnWidget,
              NextButton(
                onPressed: onTap,
                title: "test".tr,
                height: 30.w,
                activeColor: bgColor,
                borderRadius: 15,
                textStyle: Get.textTheme.displayLarge,
              )
            ],
          ),
        ),
      );
    }

    return Obx(() => controller.isConnect.value == false
        ? Container()
        : Container(
            margin: EdgeInsets.only(left: 12.w, top: 12.w, right: 12.w),
            padding: EdgeInsets.only(
                left: 12.w, right: 12.w, bottom: 18.w, top: 12.w),
            decoration: BoxDecoration(
              color: ColorUtils.fromHex("#FF000000"),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("manual_test".tr),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _getManual_item(
                        bgIcon: "icons/device_hr_bg",
                        icon: "icons/manual_icon_hr",
                        title: "heartrate".tr,
                        bgColor: ColorUtils.fromHex("#FF801A1A"),
                        onTap: () {
                          controller.onTapManualHeartrate();
                        },
                      ),
                      _getManual_item(
                        bgIcon: "icons/device_sao2_bg",
                        icon: "icons/manual_icon_sao2",
                        title: "blood_OXYGEN".tr,
                        bgColor: ColorUtils.fromHex("#FF80611A"),
                        onTap: () {
                          controller.onTapBloodOxygen();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
  }

  Widget _getDevicesCard() {
    return Obx(
      () => controller.connectDevice.value != null
          ? Container(
              height: 138.w,
              margin: EdgeInsets.only(left: 12.w, right: 12.w),
              padding: EdgeInsets.only(left: 29.w, right: 57.w),
              decoration: BoxDecoration(
                color: ColorUtils.fromHex("#FF000000"),
                borderRadius: BorderRadius.circular(14),
              ),
              child: InkWell(
                onTap: () {
                  controller.onTapAddDevices();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // margin: EdgeInsets.only(top: 26.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.connectDevice.value?.localName ?? "",
                            style: Get.textTheme.bodySmall,
                          ),
                          4.columnWidget,
                          Container(
                            width: 150.w,
                            child: Text(
                              controller.connectDevice.value?.macAddress ?? "",
                              style: Get.textTheme.displaySmall,
                            ),
                          ),
                          3.columnWidget,
                          Obx(
                            () => Text(
                              controller.isConnect.value == true
                                  ? "Linked"
                                  : "UnLink",
                              style: Get.textTheme.titleSmall,
                            ),
                          ),
                          7.columnWidget,
                          Row(
                            children: [
                              LoadAssetsImage(
                                RingDeviceModel.getBatIcon(
                                    bat: controller.batNum.value,
                                    isCharging: controller.isCharging.value),
                                width: 23,
                                height: 12,
                              ),
                              5.rowWidget,
                              Text(
                                "${controller.batNum.value}%",
                                style: Get.textTheme.displaySmall,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    LoadAssetsImage(
                      "icons/device",
                      width: 84,
                      height: 86,
                    ),
                  ],
                ),
              ),
            )
          : Container(
              height: 138.w,
              margin: EdgeInsets.only(left: 12.w, right: 12.w),
              decoration: BoxDecoration(
                color: ColorUtils.fromHex("#FF000000"),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: ColorUtils.fromHex("#FF05E6E7"),
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: () {
                  controller.onTapAddDevices();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadAssetsImage(
                      "icons/device_icon_add",
                      width: 48,
                      height: 51,
                    ),
                    20.rowWidget,
                    Text(
                      "add_device".tr,
                      style: Get.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "tabbar_devices".tr,
      centerTitle: false,
      hiddenLeading: true,
      body: SmartRefresher(
        controller: controller.refreshController,
        header: ClassicHeader(
          refreshingText: "正在连接中",
        ),
        enablePullUp: false,
        onRefresh: () {

          controller.autoScanConnect();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _getDevicesCard(),
              _getManual_test(),
              _getList(),
            ],
          ),
        ),
      ),
    );
  }
}
