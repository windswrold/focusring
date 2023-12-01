import 'dart:async';

import 'package:beering/app/data/ring_device.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/ble/bledata_serialization.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/hex_util.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeDevicesController extends GetxController {
  //TODO: Implement HomeDevicesController

  Rx<RingDeviceModel?> dbDevice = Rx(null);

  Rx<KBleState> connectType = Rx(KBleState.disconnect); //是否连接
  RxInt batNum = RxInt(0); //电池信息
  RxBool isCharging = RxBool(false); //是否充电

  StreamSubscription? deviceStateStream,
      receiveDataStream,
      isScanning,
      scanResults;

  // int _maxScanCount = 10;
  bool _isScan = false;

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

  void _updateState(KBleState state) {
    connectType.value = state;
    update(["connectType"]);
  }

  @override
  void onReady() {
    super.onReady();

    deviceStateStream = KBLEManager.deviceStateStream.listen((event) {
      if (event == BluetoothConnectionState.connected) {
        _updateState(KBleState.connected);
      } else {
        _updateState(KBleState.disconnect);
        isCharging.value = false;
        autoScanConnect();
      }
      vmPrint("deviceStateStream $event connectType $connectType");
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
      vmPrint("_isScan $_isScan isConnect $connectType ", KBLEManager.logevel);
      autoScanConnect();
    });

    scanResults = KBLEManager.scanResults.listen((results) {
      for (ScanResult d in results) {
        RingDeviceModel model = RingDeviceModel.fromResult(d);
        if (compareUUID(
            model.macAddress ?? "", dbDevice.value?.macAddress ?? "")) {
          if (connectType.value == KBleState.disconnect) {
            KBLEManager.stopScan();
            KBLEManager.connect(device: dbDevice.value!, ble: d.device);
            vmPrint("触发链接", KBLEManager.logevel);
            _updateState(KBleState.connecting);
          }
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
      dbDevice.value = a;
      autoScanConnect();
    } else {
      dbDevice.value = null;
    }
  }

  /// 已连接 获取历史数据
  /// 连接中 提示连接中
  /// 未连接 已绑定则回连 未绑定 则提示未绑定
  void onRefresh() async {
    if (connectType.value == KBleState.connected) {
      KBLEManager.sendData(
          sendData: KBLESerialization.getDayNumWithType(
              type: KHealthDataType.HEART_RATE));
      HWToast.showSucText(text: "获取历史数据中");
    } else if (connectType.value == KBleState.connecting) {
      HWToast.showSucText(text: "正在连接中");
    } else {
      if (dbDevice.value == null) {
        HWToast.showErrText(text: "未绑定设备");
      } else {
        HWToast.showErrText(text: "正在回连中");
      }
    }
    await Future.delayed(Duration(seconds: 3));
    refreshController.refreshCompleted();
  }

  void autoScanConnect() {
    if (dbDevice.value == null) {
      return;
    }
    if (connectType.value == KBleState.connected) {
      return;
    }
    if (connectType.value == KBleState.connecting) {
      return;
    }
    vmPrint("_autoScanConnect", KBLEManager.logevel);
    KBLEManager.startScan();
  }

  void onTapList(int indx) {
    if (connectType.value != KBleState.connected) {
      return;
    }
    String mac = dbDevice.value?.macAddress ?? "";
    if (mac.isEmpty) {
      return;
    }

    if (indx == 0) {
      Get.toNamed(Routes.HEARTRATE_ALERT);
    } else if (indx == 1) {
      Get.toNamed(Routes.AUTOMATIC_SETTINGS);
    } else if (indx == 2) {
      Get.toNamed(Routes.DEVICE_INFO, arguments: dbDevice.value);
    } else if (indx == 3) {
      DialogUtils.dialogResetDevices(
        onConfirm: () async {
          vmPrint("确定恢复", KBLEManager.logevel);
          KBLEManager.sendData(sendData: KBLESerialization.unBindDevice());
          await Future.delayed(Duration(milliseconds: 500));
          vmPrint("断开连接", KBLEManager.logevel);
          KBLEManager.disconnectedAllBle();
          RingDeviceModel.delTokens();
          dbDevice.value = null;
        },
      );
    } else if (indx == 4) {
      //解绑 是否解绑 y 调用接口
      //y 清除本地的 断开蓝牙

      DialogUtils.defaultDialog(
          title: "un_bind_sure".tr,
          onConfirm: () {
            AppApi.unBindDeviceStream(mac: mac).onSuccess((value) {
              HWToast.showSucText(text: "解绑成功");
              RingDeviceModel.delTokens();
              _initData();
              KBLEManager.disconnectedAllBle();
            }).onError((r) {
              HWToast.showErrText(text: r.error ?? "");
            });
          });
    }
  }

  void onTapAddDevices() async {
    if (connectType.value == KBleState.connected) {
      // DialogUtils.defaultDialog(title: "当前正在连接中，确定断开连接?",onConfirm: (){
      //
      //
      // });
      return;
    }
    if (dbDevice.value != null) {
      KBLEManager.startScan();
      return;
    }

    try {
      dynamic d = await Get.toNamed(Routes.FIND_DEVICES);
      if (d == null || d is Map) {
        return;
      }
      // await RingDeviceModel.insertTokens(d);
      dbDevice.value = d;
    } catch (a) {}
  }

  void onTapManualHeartrate() {
    if (connectType.value != KBleState.connected) {
      return;
    }

    Get.toNamed(Routes.USER_MANUALTEST, arguments: KHealthDataType.HEART_RATE);
  }

  void onTapBloodOxygen() {
    if (connectType.value != KBleState.connected) {
      return;
    }

    Get.toNamed(Routes.USER_MANUALTEST,
        arguments: KHealthDataType.BLOOD_OXYGEN);
  }
}
