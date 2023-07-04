import 'package:focusring/public.dart';
import 'package:get/get.dart';

class HeartrateAlertController extends GetxController {
  //TODO: Implement HeartrateAlertController

  var state = true.obs;

  var maxHeartAlert = 180.obs;
  var minHeartAlert = 60.obs;

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

  void onChanged(bool a) {
    state.value = a;
  }

  void showMax() {
    DialogUtils.dialogDataPicker(
      title: "max_heartrate".tr,
      datas: List.filled(10, "100"),
      symbolText: KHealthDataType.HEART_RATE.getSymbol(),
    );
  }

  void showMin() {
    DialogUtils.dialogDataPicker(
      title: "min_heartrate".tr,
      datas: List.filled(10, "100"),
      symbolText: KHealthDataType.HEART_RATE.getSymbol(),
    );
  }
}
