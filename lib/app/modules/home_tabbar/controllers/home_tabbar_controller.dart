import 'dart:io';

import 'package:beering/app/data/app_update_model.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/const/constant.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../utils/permission.dart';
import '../../home_devices/controllers/home_devices_controller.dart';
import '../../home_mine/controllers/home_mine_controller.dart';
import '../../home_state/controllers/home_state_controller.dart';

class HomeTabbarController extends GetxController {
  //TODO: Implement HomeTabbarController

  final currentIndex = 0.obs;

  final bleIsok = false.obs;

  GestureRecognizer tap = TapGestureRecognizer()
    ..onTap = () {
      launchUrlString("https://bee-ring.hlcrazy.com/api/app/common/agreement");
    };

  GestureRecognizer tap2 = TapGestureRecognizer()
    ..onTap = () {
      launchUrlString(
          "https://www.freeprivacypolicy.com/live/a5455ff9-f03c-4bb0-b0a8-d74475d6e1ac");
    };

  @override
  void onInit() {
    super.onInit();

    Get.put(HomeDevicesController());
    Get.put(HomeMineController());
    Get.put(HomeStateController());
  }

  @override
  void onReady() {
    super.onReady();

    _initData();
  }

  void cancel() async {
    DialogUtils.defaultDialog(
      title: "disagreetip".tr,
      onConfirm: () {
        confirm();
      },
      onCancel: () {},
    );
  }

  void confirm() async {
    DialogUtils.defaultDialog(
      title: "request_auth".tr + "\n\n" + "disagreetip_1".tr,
      // content: "disagreetip_1".tr,
      // title: "disagreetip_1".tr,
      onConfirm: () async {
        final aaa = await PermissionUtils.requestBle();
        bleIsok.value = aaa;
        if (aaa == false) {
          DialogUtils.defaultDialog(
            title: "request_tip07".tr,
            onConfirm: () {
              openAppSettings();
            },
          );
        }
      },
    );
  }

  void _initData() async {
    if (isAndroid) {
      final state = await PermissionUtils.checkBle();
      bleIsok.value = state;
    } else {
      bleIsok.value = true;
    }

    AppApi.checkAppUpdateStream(
            systemType: getSystemType(),
            currentVersion: GlobalValues.appInfo?.version ?? "1.0.0")
        .onSuccess((result) {
      if (result.mapResult == null) {
        return;
      }

      final value = AppUpdateVersionModel.fromJson(result.mapResult!);
      DialogUtils.defaultDialog(
        title: value.version ?? "",
        content: value.remark,
        hiddenCancel: value.forceUpdate ?? false,
        onConfirm: () {
          launchUrlString(value.downloadUrl ?? "");
        },
      );
    }).onError((r) {
      HWToast.showSucText(text: r.error ?? "");
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTap(index) {
    currentIndex.value = index;
  }
}
