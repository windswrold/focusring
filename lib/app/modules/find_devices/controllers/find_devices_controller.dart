import 'dart:async';

import 'package:beering/ble/bledata_serialization.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:beering/app/data/ring_device.dart';
import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../public.dart';

class FindDevicesController extends GetxController {
  //TODO: Implement FindDevicesController

  late AnimationController controller;

  late RxList<RingDeviceModel> scanResults = <RingDeviceModel>[].obs;

  StreamSubscription? scanStream, isScan, connect, receive;

  late RefreshController refreshController = RefreshController();

  RingDeviceModel? item;

  @override
  void onInit() {
    super.onInit();
  }

  void onCreate(AnimationController c) {
    controller = c;
  }

  @override
  void onClose() {
    KBLEManager.stopScan();
    scanStream?.cancel();
    isScan?.cancel();
    connect?.cancel();
    receive?.cancel();
    super.onClose();
  }

  void onRefresh() {
    startScan();
    refreshController.refreshCompleted();
  }

  @override
  void onReady() {
    super.onReady();

    scanStream = KBLEManager.scanResults.listen((event) {
      vmPrint("scanResults ${event.length}");
      scanResults.value =
          event.map((e) => RingDeviceModel.fromResult(e)).toList();
    });

    isScan = KBLEManager.isScanning.listen((event) {
      vmPrint("isScanning ${event.toString()}");
      if (event == true) {
        resumeAnimation();
      } else {
        pauseAnimation();
      }
    });

    connect = KBLEManager.deviceStateStream.listen((event) {
      vmPrint("BluetoothConnectionState ${event.toString()}");
      if (event == BluetoothConnectionState.connected) {
        HWToast.showSucText(text: "已连接");
      }
    });
    receive = KBLEManager.receiveDataStream.listen((event) {
      if (event.command == KBLECommandType.bindingsverify) {
        if (event.status == true) {
          HWToast.showSucText(text: event.tip);
          KBLEManager.sendData(sendData: KBLESerialization.timeSetting());
        } else {
          HWToast.showErrText(text: event.tip);
        }
      } else if (event.command == KBLECommandType.system) {
        if (event.status == true) {
          HWToast.showSucText(text: event.tip);
          Get.backDelay(result: item);
        }
      }
    });

    startScan();
  }

  void startScan() async {
    final state = await KBLEManager.checkBle();
    if (state == false) {
      return;
    }
    KBLEManager.startScan();
    controller.repeat();
  }

  void onTapItem(RingDeviceModel item) async {
    vmPrint(item.localName);
    try {
      item = item;
      KBLEManager.connect(device: item);
      HWToast.showLoading();
    } catch (e) {
      HWToast.showErrText(text: e.toString());
    }
  }

  void pauseAnimation() {
    if (controller.isAnimating) {
      controller.stop();
    }
  }

  void resumeAnimation() {
    if (!controller.isAnimating) {
      controller.repeat();
    }
  }

  void emptyDeviceTip() {
    DialogUtils.dialogNDeviceTip();
  }
}
