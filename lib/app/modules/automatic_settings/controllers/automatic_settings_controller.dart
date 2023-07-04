import 'package:get/get.dart';

import '../../../../public.dart';

class AutomaticSettingsController extends GetxController {
  //TODO: Implement AutomaticSettingsController

  var heartstate = true.obs;
  var bloodoxygenstate = true.obs;

  var heartrate_offset = 180.obs;
  var bloodoxygen_offset = 69.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onChangeHeart(bool state) {
    heartstate.value = state;
  }

  void onChangeBloodoxy(bool state) {
    bloodoxygenstate.value = state;
  }

  void showHeartrate_Offset() {
    DialogUtils.dialogDataPicker(
      title: "heartrate_interval".tr,
      datas: List.filled(10, "100"),
      symbolText: KHealthDataType.HEART_RATE.getSymbol(),
    );
  }

  void showBloodOxygen_Offset() {
    DialogUtils.dialogDataPicker(
      title: "bloodoxygen_interval".tr,
      datas: List.filled(10, "100"),
      symbolText: KHealthDataType.BLOOD_OXYGEN.getSymbol(),
    );
  }
}
