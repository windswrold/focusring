import 'package:focusring/app/data/ring_device.dart';
import 'package:focusring/public.dart';
import 'package:get/get.dart';

class HomeDevicesController extends GetxController {
  //TODO: Implement HomeDevicesController

  RxList<Map> my_defaultList = <Map>[].obs;

  Rx<RingDevice?> connectDevice = null.obs;

  @override
  void onInit() {
    super.onInit();

    my_defaultList = [
      {
        "a": "icons/device_icon_hrwarning",
        "b": "heartrate_alert",
        "d": "On",
      },
      {
        "a": "icons/device_icon_auto",
        "b": "automatic_settings",
      },
      {
        "a": "icons/device_icon_upgrade",
        "b": "ota_upgrade",
      },
      {
        "a": "icons/device_icon_reset",
        "b": "restore_settings",
      },
    ].obs;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapList(int indx) {
    if (indx == 0) {
      Get.toNamed(Routes.HEARTRATE_ALERT);
    } else if (indx == 1) {
      Get.toNamed(Routes.AUTOMATIC_SETTINGS);
    } else if (indx == 2) {
      Get.toNamed(Routes.DEVICE_INFO);
    } else if (indx == 3) {
      if (connectDevice.value == null) {
        DialogUtils.defaultDialog(
          title: "empty_unbind".tr,
          content: "empty_unbindtip".tr,
          alignment: Alignment.center,
        );
        return;
      }
      DialogUtils.dialogResetDevices();
    }
  }

  void onTapAddDevices() {
    Get.toNamed(Routes.FIND_DEVICES);
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
