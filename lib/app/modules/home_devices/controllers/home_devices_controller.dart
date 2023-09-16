import 'dart:async';

import 'package:beering/app/data/ring_device.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/ble/bledata_serialization.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/hex_util.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class HomeDevicesController extends GetxController {
  //TODO: Implement HomeDevicesController

  Rx<RingDeviceModel?> connectDevice = Rx<RingDeviceModel?>(null);

  RxBool isConnect = false.obs;

  RxInt batNum = RxInt(0);
  RxBool isCharging = RxBool(false);

  StreamSubscription? deviceStateStream, receiveDataStream;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    deviceStateStream = KBLEManager.deviceStateStream.listen((event) {
      if (event == BluetoothConnectionState.connected) {
        isConnect.value = true;
      } else {
        isConnect.value = false;
      }
    });

    receiveDataStream = KBLEManager.receiveDataStream.listen((event) {
      if (event.command == KBLECommandType.battery) {
        final a = event.value;
        batNum.value = a;
        vmPrint("电量是 $a", KBLEManager.logevel);
      } else if (event.command == KBLECommandType.charger) {
        vmPrint("充电状态 ${event.tip}", KBLEManager.logevel);
        isCharging.value = event.status;
        if (event.value == 2) {
          batNum.value = 100;
        }
      }
    });
  }

  @override
  void onClose() {
    receiveDataStream?.cancel();
    deviceStateStream?.cancel();
    super.onClose();
  }

  void onTapList(int indx) {
    if (indx == 0) {
      Get.toNamed(Routes.HEARTRATE_ALERT);
    } else if (indx == 1) {
      Get.toNamed(Routes.AUTOMATIC_SETTINGS);
    } else if (indx == 2) {
      if (connectDevice.value == null) {
        DialogUtils.defaultDialog(
          title: "empty_unbind".tr,
          content: "empty_unbindtip".tr,
          alignment: Alignment.center,
        );
        return;
      }
      Get.toNamed(Routes.DEVICE_INFO, arguments: connectDevice.value);
    } else if (indx == 3) {
      if (connectDevice.value == null) {
        DialogUtils.defaultDialog(
          title: "empty_unbind".tr,
          content: "empty_unbindtip".tr,
          alignment: Alignment.center,
        );
        return;
      }
      DialogUtils.dialogResetDevices();
    }
  }

  void onTapAddDevices() async {
    if (!inProduction) {
      if (connectDevice.value != null) {
        //电量获取
        // KBLEManager.onValueReceived(HEXUtil.decode("EEEE0003060012"));
        //充电状态
        // KBLEManager.onValueReceived(HEXUtil.decode("EEEE0003070002"));
        //心率有3天暑假
        // KBLEManager.onValueReceived(HEXUtil.decode("EEEE00040303AA03"));
        //回复心率数据
        KBLEManager.onValueReceived(HEXUtil.decode("EEEE00050303bb0101"));
        return;
      }
    }

    try {
      dynamic d = await Get.toNamed(Routes.FIND_DEVICES);
      if (d == null || d is Map) {
        return;
      }
      // await RingDeviceModel.insertTokens(d);
      connectDevice.value = d;
    } catch (a) {}
  }

  void onTapManualHeartrate() {
    if (connectDevice.value == null) {
      DialogUtils.defaultDialog(
        title: "empty_unbind".tr,
        content: "empty_unbindtip".tr,
        alignment: Alignment.center,
      );
      return;
    }

    Get.toNamed(Routes.USER_MANUALTEST, arguments: KHealthDataType.HEART_RATE);
  }

  void onTapBloodOxygen() {
    if (connectDevice.value == null) {
      DialogUtils.defaultDialog(
        title: "empty_unbind".tr,
        content: "empty_unbindtip".tr,
        alignment: Alignment.center,
      );
      return;
    }

    Get.toNamed(Routes.USER_MANUALTEST,
        arguments: KHealthDataType.BLOOD_OXYGEN);
  }
}
