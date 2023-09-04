import 'dart:async';

import 'package:beering/app/data/ring_device.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/ble/bledata_serialization.dart';
import 'package:beering/public.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class HomeDevicesController extends GetxController {
  //TODO: Implement HomeDevicesController

  Rx<RingDeviceModel?> connectDevice = Rx<RingDeviceModel?>(null);

  RxBool isConnect = false.obs;
  RxInt bat = 10.obs;

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
        bat.value = a as int;
        KBLEManager.sendData(
            sendData: KBLESerialization.getHeartHistoryDataByCurrent(
                isHeart: KHealthDataType.HEART_RATE));
      } else if (event.command == KBLECommandType.ppg) {
        if (event.status == true) {
          KBLEManager.sendData(
              sendData: KBLESerialization.getStepsHistoryDataByCurrent());
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
    try {
      dynamic d = (await Get.toNamed(Routes.FIND_DEVICES));
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
