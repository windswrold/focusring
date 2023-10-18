import 'package:beering/utils/permission.dart';
import 'package:get/get.dart';

class PermissSettingController extends GetxController {
  //TODO: Implement PermissSettingController

  RxBool ble = RxBool(false);

  @override
  void onInit() {
    super.onInit();

    PermissionUtils.checkBle().then((value) => {
          ble.value = value,
        });
  }

  @override
  void onReady() {
    super.onReady();
  }

  void requestLocal() {
    PermissionUtils.requestBle().then((value) => {
          ble.value = value,
        });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
