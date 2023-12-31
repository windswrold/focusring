import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
import 'package:beering/views/dialog_widgets/dialog_utils.dart';
import 'package:get/get.dart';

class SettingUserInfoController extends GetxController {
  //TODO: Implement SettingUserInfoController

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

  void onTapList(int index) async {
    Map<String, dynamic> params = Map();

    final user = SPManager.getGlobalUser();

    final units = user!.units!;

    final height = user.displayHeight(displaySymbol: false);
    final weigtht = user.displayWeight(displaySymbol: false);

    if (index == 0) {
      final name = await DialogUtils.dialogInputNickname();
      if (name == null) {
        return;
      }
      params["username"] = name;
    } else if (index == 1) {
      final selectIndex = await DialogUtils.dialogDataPicker(
        title: "yours_sex".tr,
        datas: ["man".tr, "woman".tr],
      );
      if (selectIndex == null) {
        return;
      }
      params["sex"] = selectIndex + 1;
    } else if (index == 2) {
      final arrs = ListEx.generateHeightArr(units);
      final selectIndex = await DialogUtils.dialogDataPicker(
        title: "yours_height".tr,
        datas: arrs,
        symbolText: units == KUnitsType.metric ? "cm" : "in",
        initialItem: arrs.indexOf(height),
        symbolRight: 124.w,
      );
      if (selectIndex == null) {
        return;
      }
      params[units == KUnitsType.metric ? "heightMetric" : "heightBritish"] =
          arrs[selectIndex];
    }
    if (index == 3) {
      final arrs = ListEx.generateWeightArr(units);
      final selectIndex = await DialogUtils.dialogDataPicker(
        title: "youres_weight".tr,
        datas: arrs,
        symbolText: units == KUnitsType.metric ? "kg" : "lb",
        initialItem: arrs.indexOf(weigtht),
        symbolRight: 124.w,
      );
      if (selectIndex == null) {
        return;
      }
      params[units == KUnitsType.metric ? "weightMetric" : "weightBritish"] =
          arrs[selectIndex];
    }

    AppApi.editUserInfoStream(model: params).onSuccess((value) {
      HWToast.showSucText(text: "modify_success".tr);
      // Get.backDelay();
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }
}
