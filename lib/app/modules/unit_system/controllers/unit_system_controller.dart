import 'package:focusring/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:focusring/net/app_api.dart';
import 'package:focusring/public.dart';
import 'package:get/get.dart';

class UnitSystemController extends GetxController {
  //TODO: Implement UnitSystemController

  Rx<KUnits> units = KUnits.metric.obs;
  Rx<KTempUnits> tempUnits = KTempUnits.celsius.obs;

  @override
  void onInit() {
    super.onInit();

    AppViewController app = Get.find(tag: AppViewController.tag);

    units.value = app.user.value?.units ?? KUnits.metric;
    tempUnits.value = app.user.value?.tempUnit ?? KTempUnits.celsius;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapUnit(KUnits index) {
    units.value = index;
    requestData();
  }

  void onTapTempUnit(KTempUnits index) {
    tempUnits.value = index;
    requestData();
  }

  void requestData() {
    Map<String, dynamic> params = {
      "units": units.value.getRaw(),
      "tempUnit": tempUnits.value.getRaw(),
    };

    AppApi.editUserInfo(model: params).onSuccess((value) {
      HWToast.showSucText(text: "modify_success".tr);
      Get.backDelay();
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }
}
