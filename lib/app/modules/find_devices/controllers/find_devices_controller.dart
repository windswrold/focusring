import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:focusring/app/data/ring_device.dart';
import 'package:focusring/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:focusring/ble/ble_manager.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../public.dart';

class FindDevicesController extends GetxController {
  //TODO: Implement FindDevicesController

  late AnimationController controller;

  late RxList<RingDevice> scanResults = <RingDevice>[].obs;

  StreamSubscription? scanStream, isScan;

  late RefreshController refreshController = RefreshController();

  @override
  void onInit() {
    super.onInit();
  }

  void onCreate(AnimationController c) {
    controller = c;
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
      scanResults.value = event.map((e) => RingDevice.fromResult(e)).toList();
    });

    isScan = KBLEManager.isScanning.listen((event) {
      vmPrint("isScanning ${event.toString()}");
      if (event == true) {
        resumeAnimation();
      } else {
        pauseAnimation();
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

  void onTapItem(RingDevice item) async {
    vmPrint(item.localName);
    try {
      Stream<BluetoothConnectionState>? a =
          await KBLEManager.connect(device: item);
      if (a == null) {
        return;
      }
      HWToast.showLoading();
      var stateConnect = a.listen((event) {
        vmPrint("BluetoothConnectionState ${event.toString()}");
        if (event == BluetoothConnectionState.connected) {
          HWToast.showSucText(text: "已连接");
          KBLEManager.stopScan();
          // KBLEManager.findCharacteristics(KBLEManager.getDevice(device: item));
          Get.back<RingDevice>(result: item);
        }
      });
    } catch (e) {
      HWToast.showErrText(text: e.toString());
    }
  }

  @override
  void onClose() {
    KBLEManager.stopScan();
    scanStream?.cancel();
    isScan?.cancel();
    super.onClose();
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
