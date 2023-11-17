import 'dart:async';

import 'package:beering/app/data/ring_device.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/ble/bledata_serialization.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/hex_util.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeDevicesController extends GetxController {
  //TODO: Implement HomeDevicesController

  Rx<RingDeviceModel?> connectDevice = Rx(null);

  RxBool isConnect = false.obs;

  RxInt batNum = RxInt(0);
  RxBool isCharging = RxBool(false);

  StreamSubscription? deviceStateStream,
      receiveDataStream,
      isScanning,
      scanResults;

  // int _maxScanCount = 10;
  bool _isScan = false;
  ScanResult? _cacheDevices;

  late RefreshController refreshController = RefreshController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    receiveDataStream?.cancel();
    deviceStateStream?.cancel();
    isScanning?.cancel();
    scanResults?.cancel();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();

    deviceStateStream = KBLEManager.deviceStateStream.listen((event) {
      vmPrint("deviceStateStream $event");
      if (event == BluetoothConnectionState.connected) {
        isConnect.value = true;
        // _maxScanCount = 10;
      } else {
        isConnect.value = false;
        autoScanConnect();
      }
      refreshController.refreshCompleted();
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

    isScanning = KBLEManager.isScanning.listen((event) {
      _isScan = event;
      vmPrint("_isScan $_isScan isConnect $isConnect $_cacheDevices",
          KBLEManager.logevel);
      if (_isScan == false &&
          isConnect.value == false &&
          connectDevice.value != null &&
          _cacheDevices == null) {
        autoScanConnect();
      }
    });

    scanResults = KBLEManager.scanResults.listen((results) {
      for (ScanResult d in results) {
        vmPrint(
            "scanResults ${d.toString()}  ${connectDevice.value?.remoteId}");
        if (d.device.remoteId.str == (connectDevice.value?.remoteId ?? "") &&
            _cacheDevices == null) {
          _cacheDevices = d;
          KBLEManager.stopScan();
          KBLEManager.connect(device: connectDevice.value!, ble: d.device);
        }
      }
    });

    _initData();
  }

  void _initData() async {
    if (SPManager.getGlobalUser() == null) {
      return;
    }

    final a = await RingDeviceModel.queryUserAllWithSelect(
        SPManager.getGlobalUser()!.id.toString(), true);
    if (a != null) {
      connectDevice.value = a;
      autoScanConnect();
    }
  }

  void autoScanConnect() {
    // if (_maxScanCount <= 0) {
    //   return;
    // }

    if (isConnect.value == true) {
      refreshController.refreshCompleted();
      return;
    }
    if (connectDevice.value == null) {
      refreshController.refreshFailed();
      return;
    }
    // _maxScanCount -= 1;
    vmPrint("_autoScanConnect  次", KBLEManager.logevel);
    refreshController.requestRefresh();
    // if (_cacheDevices == null) {
    KBLEManager.startScan();
    // } else {
    //   KBLEManager.connect(
    //       device: connectDevice.value!, ble: _cacheDevices!.device);
    // }
  }

  void onTapList(int indx) {
    if (indx == 0) {
      Get.toNamed(Routes.HEARTRATE_ALERT);
    } else if (indx == 1) {
      Get.toNamed(Routes.AUTOMATIC_SETTINGS);
    } else if (indx == 2) {
      if (isConnect.value == false) {
        DialogUtils.defaultDialog(
          title: "empty_unbind".tr,
          content: "empty_unbindtip".tr,
          alignment: Alignment.center,
        );
        return;
      }
      Get.toNamed(Routes.DEVICE_INFO, arguments: connectDevice.value);
    } else if (indx == 3) {
      // if (isConnect.value == false) {
      //   DialogUtils.defaultDialog(
      //     title: "empty_unbind".tr,
      //     content: "empty_unbindtip".tr,
      //     alignment: Alignment.center,
      //   );
      //   return;
      // }
      DialogUtils.dialogResetDevices(
        onConfirm: () async {
          vmPrint("确定恢复", KBLEManager.logevel);
          KBLEManager.sendData(sendData: KBLESerialization.unBindDevice());
          await Future.delayed(Duration(milliseconds: 500));
          vmPrint("断开连接", KBLEManager.logevel);
          KBLEManager.disconnectedAllBle();
          RingDeviceModel.delTokens();
          connectDevice.value = null;
        },
      );
    }
  }

  void onTapAddDevices() async {
    if (isConnect.value == true) {
      // DialogUtils.defaultDialog(title: "当前正在连接中，确定断开连接?",onConfirm: (){
      //
      //
      // });
      return;
    }
    if (connectDevice.value != null) {
      _cacheDevices = null;
      KBLEManager.startScan();
      return;
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
