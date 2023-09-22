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

  StreamSubscription? deviceStateStream,
      receiveDataStream,
      isScanning,
      scanResults;
  int _maxScanCount = 10;
  bool _isScan = false;
  ScanResult? _connect;

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
        _maxScanCount = 10;
      } else {
        isConnect.value = false;
        _autoScanConnect();
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

    isScanning = KBLEManager.isScanning.listen((event) {
      _isScan = event;
      vmPrint("_isScan $_isScan isConnect $isConnect $_connect",
          KBLEManager.logevel);
      if (_isScan == false &&
          isConnect.value == false &&
          connectDevice.value != null &&
          _connect == null) {
        _maxScanCount -= 1;
        vmPrint("扫描超时了还没连接上继续扫描 还剩$_maxScanCount 次", KBLEManager.logevel);
        _autoScanConnect();
      }
    });

    scanResults = KBLEManager.scanResults.listen((results) {
      for (ScanResult d in results) {
        vmPrint(
            "scanResults ${d.toString()}  ${connectDevice.value?.remoteId}");
        if (d.device.remoteId.str == (connectDevice.value?.remoteId ?? "") &&
            _connect == null) {
          _connect = d;
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
    if (a.tryFirst != null) {
      connectDevice.value = a.tryFirst;
      _autoScanConnect();
    }
  }

  void _autoScanConnect() {
    if (_maxScanCount <= 0) {
      return;
    }
    if (connectDevice.value == null) {
      return;
    }
    if (_connect == null) {
      KBLEManager.startScan();
    } else {
      KBLEManager.connect(device: connectDevice.value!, ble: _connect!.device);
    }
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
      if (isConnect.value == false) {
        DialogUtils.defaultDialog(
          title: "empty_unbind".tr,
          content: "empty_unbindtip".tr,
          alignment: Alignment.center,
        );
        return;
      }
      DialogUtils.dialogResetDevices(
        onConfirm: () async {
          vmPrint("确定恢复", KBLEManager.logevel);
          KBLEManager.sendData(sendData: KBLESerialization.unBindDevice());
          await Future.delayed(Duration(milliseconds: 500));
          vmPrint("断开连接", KBLEManager.logevel);
          KBLEManager.disAllConnect();
          RingDeviceModel.delTokens(connectDevice.value!);
          connectDevice.value = null;
        },
      );
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
        // KBLEManager.onValueReceived(HEXUtil.decode("EEEE00050303bb0101"));

        //设备接受测量
        // KBLEManager.onValueReceived(HEXUtil.decode("EEEE000403000100"));

        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00f00303bb0201e7070910000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6"));

        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee003e0303bb0202e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"));

        // // 血氧
        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00f00308bb0201e7070910000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6"));
        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee003e0308bb0202e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"));
        // // 步数
        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00690403bb0101e70709100000000064000000c80000002c01000090010000f401000058020000bc0200002003000084030000e80300004c040000b00400001405000078050000dc05000040060000a4060000080700006c070000d00700003408000098080000fc080000"));
        // 睡眠
        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00f00501bb0501e7070910000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"));

        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00f00501bb050200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"));
        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00f00501bb050300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"));
        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00f00501bb050400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"));
        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00f00501bb050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"));

        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00f00501bb0501e7070911e707091000000001e437066588b1066507024d00000000007f014a0088001a000000000016000000e437066521000100a03f06650a000200f841066522000100f049066507000200944b06651d00010060520665120002009856066524000100085f06650c000200d86106651e000100e068066512000200186d06651d000100e4730665120002001c7806651e000100247f06650c000200f48106652d000100808c066508000200608e06654d0001006ca006650b00020000a306652700010024ac0665160002004cb106650100010088b1066500000000000000000000000000000000000000"));
        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00f00501bb050200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"));
        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00f00501bb050300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"));
        //
        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00f00501bb050400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"));
        // KBLEManager.onValueReceived(HEXUtil.decode(
        //     "eeee00490501bb05050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000"));
        // return;
      }
    }

    if (isConnect.value == true) {
      return;
    }
    if (connectDevice.value != null) {
      _autoScanConnect();
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
