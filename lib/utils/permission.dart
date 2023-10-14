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
      title: "提示",
      content: "在使用过程中，本应用需要收集位置数据以支持BLE用于发现，添加和管理设备。",
      // confirmT: "Allow",
      // cancelT: "Not allow",
      conttentColor: Colors.red,
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



    List<Permission> a = perList();
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
    List<Permission> a = perList();
    Map<Permission, PermissionStatus> statuses = await a.request();
    bool isok = true;
    for (var element in statuses.values) {
      if (element != PermissionStatus.granted) {
        isok = false;
        break;
      }
    }

    await Future.delayed(Duration(milliseconds: 500));

    return checkBle();
  }

  static List<Permission> perList() {
    if (isAndroid == true) {
      int androidApiVersion = GlobalValues.androidApiVersion() ?? 30;
      if (androidApiVersion <= 30) {
        return [Permission.location];
      }
      return [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ];
    }
    return [Permission.bluetooth];
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
