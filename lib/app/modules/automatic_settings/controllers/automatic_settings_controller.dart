import 'package:get/get.dart';

import '../../../../public.dart';

class AutomaticSettingsController extends GetxController {
  //TODO: Implement AutomaticSettingsController

  var heartstate = true.obs;
  var bloodoxygenstate = true.obs;

  var heartrate_offset = "5".obs;
  var bloodoxygen_offset = "4".obs;

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
    if (heartstate.value == false) {
      return;
    }

    var list = ["5", "30", "60"];
    int selectIndex = list.indexOf(heartrate_offset.value);
    DialogUtils.dialogDataPicker(
      title: "heartrate_interval".tr,
      datas: list,
      symbolText: "  min",
      symbolRight: 100.w,
      initialItem: selectIndex,
      onSelectedItemChanged: (index) {
        selectIndex = index;
      },
      onConfirm: () {
        if (selectIndex == null) {
          return;
        }
        heartrate_offset.value = list[selectIndex!];
      },
    );
  }

  void showBloodOxygen_Offset() {
    if (bloodoxygenstate.value == false) {
      return;
    }
    var list = ["4", "6", "8", "12"];
    int selectIndex = list.indexOf(bloodoxygen_offset.value);
    DialogUtils.dialogDataPicker(
      title: "bloodoxygen_interval".tr,
      datas: list,
      symbolText: KHealthDataType.BLOOD_OXYGEN.getSymbol(),
      symbolRight: 100.w,
      initialItem: selectIndex,
      onSelectedItemChanged: (index) {
        selectIndex = index;
      },
      onConfirm: () {
        if (selectIndex == null) {
          return;
        }
        bloodoxygen_offset.value = list[selectIndex!];
      },
    );
  }
}
