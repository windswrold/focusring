import 'package:focusring/public.dart';
import 'package:get/get.dart';

class HomeDevicesController extends GetxController {
  //TODO: Implement HomeDevicesController

  RxList<Map> my_defaultList = <Map>[].obs;

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
    if (indx == 3) {
      //恢复出厂
      Get.defaultDialog(
        title: "",
        titlePadding: EdgeInsets.zero,
        backgroundColor: ColorUtils.fromHex("#FF232126"),
        radius: 16,
        contentPadding: EdgeInsets.zero,
        content: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30.w, bottom: 35.w),
              child: Text(
                "sure_reset".tr,
                style: Get.textTheme.displayLarge,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: NextButton(
                    onPressed: () {
                      Get.back();
                    },
                    title: "cancel".tr,
                    activeColor: Colors.transparent,
                    textStyle: Get.textTheme.titleMedium,
                  ),
                ),
                Container(
                  width: 1,
                  height: 32.w,
                  color: ColorUtils.fromHex("#FF707070"),
                ),
                Expanded(
                  child: NextButton(
                    onPressed: () {
                      Get.back();
                    },
                    title: "confirm".tr,
                    activeColor: Colors.transparent,
                    textStyle: Get.textTheme.displayLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
        // confirm: NextButton(onPressed: () {}, title: "confirm".tr),
        // cancel: NextButton(onPressed: () {}, title: "cancel".tr),
        // textCancel: "cancel".tr,xxxx
        // textConfirm: "confirm".tr,
      );
    }
  }

  void onTapAddDevices() {}
}
