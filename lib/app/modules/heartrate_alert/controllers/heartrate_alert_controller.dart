import 'package:focusring/net/app_api.dart';
import 'package:focusring/public.dart';
import 'package:get/get.dart';

class HeartrateAlertController extends GetxController {
  //TODO: Implement HeartrateAlertController

  Rx<bool?> alertSwitch = false.obs;
  final maxHeartAlert = "180".obs;
  final minHeartAlert = "60".obs;

  @override
  void onInit() {
    super.onInit();

    final us = SPManager.getGlobalUser();
    alertSwitch.value = us?.heartRateWarnSwitch;
    maxHeartAlert.value = (us?.maxHeartRate ?? 160).toString();
    minHeartAlert.value = (us?.minHeartRate ?? 40).toString();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onChanged(bool a) {
    alertSwitch.value = a;
    _requestData({"heartRateWarnSwitch": a});
  }

  void showMax() async {
    final arrs = ListEx.generateHeartRateMaxArr();
    final index = await DialogUtils.dialogDataPicker(
      title: "max_heartrate".tr,
      datas: ListEx.generateHeartRateMaxArr(),
      symbolText: KHealthDataType.HEART_RATE.getSymbol(),
      initialItem: arrs.indexOf(maxHeartAlert.value.toString()),
    );
    maxHeartAlert.value = arrs[index];
    _requestData({"maxHeartRate": arrs[index]});
  }

  void showMin() async {
    final arrs = ListEx.generateHeartRateMinArr();
    final index = await DialogUtils.dialogDataPicker(
      title: "min_heartrate".tr,
      datas: arrs,
      symbolText: KHealthDataType.HEART_RATE.getSymbol(),
      initialItem: arrs.indexOf(minHeartAlert.value.toString()),
    );
    minHeartAlert.value = arrs[index];
    _requestData({"minHeartRate": arrs[index]});
  }

  void _requestData(Map<String, dynamic> params) {
    AppApi.editUserInfo(model: params).onSuccess((value) {
      HWToast.showSucText(text: "modify_success".tr);
      // Get.backDelay();
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }
}
