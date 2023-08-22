import 'package:beering/net/app_api.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class AutomaticSettingsController extends GetxController {
  //TODO: Implement AutomaticSettingsController

  final heartRateAutoTestSwitch = false.obs;
  final bloodOxygenAutoTestSwitch = false.obs;

  final heartRateAutoTestInterval = "5".obs;
  final bloodOxygenAutoTestInterval = "4".obs;

  @override
  void onInit() {
    super.onInit();

    final us = SPManager.getGlobalUser();
    heartRateAutoTestSwitch.value = us?.heartRateAutoTestSwitch ?? false;
    bloodOxygenAutoTestSwitch.value = us?.bloodOxygenAutoTestSwitch ?? false;
    heartRateAutoTestInterval.value =
        (us?.heartRateAutoTestInterval ?? 5).toString();
    bloodOxygenAutoTestInterval.value =
        (us?.bloodOxygenAutoTestInterval ?? 4).toString();
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
    heartRateAutoTestSwitch.value = state;
    _requestData({"heartRateAutoTestSwitch": state});
  }

  void onChangeBloodoxy(bool state) {
    bloodOxygenAutoTestSwitch.value = state;
    _requestData({"bloodOxygenAutoTestSwitch": state});
  }

  void showHeartrate_Offset() async {
    final arrs = ListEx.generateHeartRateAutoTestInterval();
    final selectIndex = await DialogUtils.dialogDataPicker(
      title: "heartrate_interval".tr,
      datas: arrs,
      symbolText: "  min",
      symbolRight: 100.w,
      initialItem: arrs.indexOf(heartRateAutoTestInterval.value),
    );
    heartRateAutoTestInterval.value = arrs[selectIndex];
    _requestData({"heartRateAutoTestInterval": arrs[selectIndex]});
  }

  void showBloodOxygen_Offset() async {
    final arrs = ListEx.generateBloodOxygenAutoTestInterval();
    final selectIndex = await DialogUtils.dialogDataPicker(
      title: "bloodoxygen_interval".tr,
      datas: arrs,
      symbolText: KHealthDataType.BLOOD_OXYGEN.getSymbol(),
      symbolRight: 100.w,
      initialItem: arrs.indexOf(bloodOxygenAutoTestInterval.value),
    );
    bloodOxygenAutoTestInterval.value = arrs[selectIndex];
    _requestData({"bloodOxygenAutoTestInterval": arrs[selectIndex]});
  }

  void _requestData(Map<String, dynamic> params) {
    AppApi.editUserInfoStream(model: params).onSuccess((value) {
      HWToast.showSucText(text: "modify_success".tr);
      // Get.backDelay();
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }
}
