import 'package:focusring/utils/console_logger.dart';
import 'package:permission_handler/permission_handler.dart';
import '../public.dart';

class PermissionUtils {
  // static Future<bool> checkBlePermissions() async {
  //   if (Constant.isAndroid) {
  //     if (await Permission.location.isGranted == true) {
  //      vmPrint("Permission  true");
  //       return true;
  //     }
  //     PermissionStatus status = await Permission.location.request();
  //    vmPrint("Permission  $status");
  //     return status == PermissionStatus.granted;
  //   }
  //   return true;
  // }

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

  static Future<bool> checkStoragePermissions() async {
    if (await Permission.storage.isGranted == true) {
      return true;
    } else {
      PermissionStatus status = await Permission.storage.request();
      vmPrint("Permission  $status");
      return status == PermissionStatus.granted;
    }
  }

  /// Permission prompt dialog
  // static showDialog(
  //     BuildContext cxt, String title, String content, ok(), cancel()) {
  //   showCupertinoDialog<int>(
  //       context: cxt,
  //       builder: (cxt) {
  //         return CupertinoAlertDialog(
  //           title: Text(title),
  //           content: Text(content),
  //           actions: <Widget>[
  //             CupertinoDialogAction(
  //               child: Text("Go to open"),
  //               onPressed: () {
  //                 ok();
  //               },
  //             ),
  //             CupertinoDialogAction(
  //               child: Text("cancel"),
  //               onPressed: () {
  //                 cancel();
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

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
