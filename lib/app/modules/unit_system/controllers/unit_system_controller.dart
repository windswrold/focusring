import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
import 'package:get/get.dart';

class UnitSystemController extends GetxController {
  //TODO: Implement UnitSystemController

  Rx<KUnitsType> units = KUnitsType.metric.obs;
  Rx<KTempUnitsType> tempUnits = KTempUnitsType.celsius.obs;

  @override
  void onInit() {
    super.onInit();

    AppViewController app = Get.find(tag: AppViewController.tag);

    units.value = app.user.value?.units ?? KUnitsType.metric;
    tempUnits.value = app.user.value?.tempUnit ?? KTempUnitsType.celsius;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapUnit(KUnitsType index) {
    units.value = index;
    requestData();
  }

  void onTapTempUnit(KTempUnitsType index) {
    tempUnits.value = index;
    requestData();
  }

  void requestData() {
    Map<String, dynamic> params = {
      "units": units.value.getRaw(),
      "tempUnit": tempUnits.value.getRaw(),
    };

    AppApi.editUserInfoStream(model: params).onSuccess((value) {
      HWToast.showSucText(text: "modify_success".tr);
      Get.backDelay();
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }
}
