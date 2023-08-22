import 'package:beering/utils/console_logger.dart';
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

  static checkPermission(
      {required List<Permission> permissionList,
      VoidCallback? onSuccess,
      VoidCallback? onFailed,
      VoidCallback? goSetting}) async {
    ///
    List<Permission> newPermissionList = [];

    ///
    for (Permission permission in permissionList) {
      PermissionStatus status = await permission.status;

      ///
      if (!status.isGranted) {
        newPermissionList.add(permission);
      }
    }

    if (newPermissionList.isNotEmpty) {
      PermissionStatus permissionStatus =
          await requestPermission(newPermissionList);

      switch (permissionStatus) {
        case PermissionStatus.denied:
          onFailed != null ? onFailed() : defaultCall("权限申请失败");
          break;

        case PermissionStatus.granted:
          onSuccess != null ? onSuccess() : defaultCall("权限申请成功");
          break;

        case PermissionStatus.restricted:
        case PermissionStatus.limited:
        case PermissionStatus.permanentlyDenied:
          goSetting != null ? goSetting() : openAppSettings();
          break;
      }
    } else {
      onSuccess != null ? onSuccess() : defaultCall("权限申请成功");
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
