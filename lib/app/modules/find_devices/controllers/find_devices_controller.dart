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

  late StreamSubscription scanStream;

  late RefreshController refreshController = RefreshController();

  @override
  void onInit() {
    super.onInit();
  }

  void onCreate(AnimationController c) {
    controller = c;
  }

  void onRefresh() {
    KBLEManager.startScan();
    refreshController.refreshCompleted();
  }

  @override
  void onReady() {
    super.onReady();

    KBLEManager.startScan();
    scanStream = KBLEManager.scanResults.listen((event) {
      vmPrint("scanResults ${event.toString()}");
      scanResults.value = event.map((e) => RingDevice.fromResult(e)).toList();
    });

    KBLEManager.isScanning.listen((event) {
      vmPrint("isScanning ${event.toString()}");
      if (event == true) {
        resumeAnimation();
      } else {
        pauseAnimation();
      }
    });
  }

  void onTapItem(RingDevice item) async {
    vmPrint(item.localName);
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
        Get.toNamed(Routes.TESTDFU, arguments: item);
      }
    });
  }

  @override
  void onClose() {
    scanStream.cancel();
    KBLEManager.stopScan();
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
}
