import 'dart:async';

import 'package:beering/ble/ble_manager.dart';
import 'package:beering/utils/console_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import '../public.dart';

class PermissionUtils {
  static Future<bool> checkCamera() async {
    if (await Permission.camera.isGranted == true) {
      vmPrint("Permission  true");
      return true;
    }
    PermissionStatus status = await Permission.camera.request();
    vmPrint("Permission  $status");
    if (status != PermissionStatus.granted) {}
    return status == PermissionStatus.granted;
  }

  /// Permission prompt dialog
  static Future<bool> showBleDialog() async {
    if (isIOS == true) {
      return Future.value(true);
    }
    Completer<bool> c = Completer();
    // final a = SPManager.getInstallStatus();
    // if (a == false) {
    // SPManager.setInstallStatus();
    DialogUtils.defaultDialog(
      title: "request".tr,
      content: "request_tip".tr,
      confirmT: "Allow",
      cancelT: "Not allow",
      onConfirm: () async {
        c.complete(true);
      },
      onCancel: () {
        c.complete(false);
      },
    );
    // }
    return c.future;
  }

  static Future<bool> checkBle() async {
    List<Permission> a = [];
    if (isAndroid == true) {
      a = [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.bluetooth
      ];
    } else {
      a = [
        Permission.bluetooth,
      ];
    }
    bool isok = true;
    for (var i = 0; i < a.length; i++) {
      Permission perItem = a[i];
      PermissionStatus status = await perItem.status;
      if (status != PermissionStatus.granted) {
        isok = false;
        break;
      }
    }

    return isok;
  }

  static Future<bool> requestBle() async {
    List<Permission> a = [];
    if (isAndroid == true) {
      a = [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.bluetooth
      ];
    } else {
      a = [
        Permission.bluetooth,
      ];
    }

    Map<Permission, PermissionStatus> statuses = await a.request();
    bool isok = true;
    for (var element in statuses.values) {
      if (element != PermissionStatus.granted) {
        isok = false;
        break;
      }
    }
    return isok;
  }

  static Future<bool> checkStoragePermissions() async {
    if (await Permission.storage.isGranted == true) {
      return true;
    } else {
      PermissionStatus status = await Permission.storage.request();
      vmPrint("Permission  $status");
      return status == PermissionStatus.granted;
    }
  }

  static Future<PermissionStatus> requestPermission(
      List<Permission> permissionList) async {
    Map<Permission, PermissionStatus> statuses = await permissionList.request();
    PermissionStatus currentPermissionStatus = PermissionStatus.granted;
    statuses.forEach((key, value) {
      if (!value.isGranted) {
        currentPermissionStatus = value;
        return;
      }
    });
    return currentPermissionStatus;
  }

  static void defaultCall(String? msg) {}
}
