import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:focusring/utils/console_logger.dart';
import 'package:focusring/utils/custom_toast.dart';
import 'package:focusring/utils/permission.dart';
import 'package:get/get.dart';

class AppViewController extends GetxController {
  //TODO: Implement AppViewController

  late FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  late StreamSubscription isScanningSubscription,
      stateSubscription,
      scanResultsSubscription;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    isScanningSubscription = flutterBlue.isScanning.listen((event) {
      vmPrint(event);
    });
  }

  @override
  void onClose() {
    stateSubscription?.cancel();
    isScanningSubscription?.cancel();
    super.onClose();
  }

  void startScan({Duration timeout = const Duration(seconds: 20)}) async {
    if ((await checkBle()) == false) {
      return;
    }

    if (flutterBlue.isScanningNow) {
      return;
    }

    flutterBlue.startScan(timeout: timeout);
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });
  }

  Future<bool> checkBle() async {
    bool a = await PermissionUtils.checkBle();
    if (a == false) {
      HWToast.showText(text: "permission_err".tr);
      return false;
    }

    while ((await flutterBlue.isAvailable) == false) {
      vmPrint("a");
      await Future.delayed(Duration(seconds: 2));
    }

    if ((await flutterBlue.isOn) == false) {
      return false;
    }

    return true;
  }

  void stopScan() {
    flutterBlue.stopScan();
  }
}
