import 'package:focusring/public.dart';
import 'package:focusring/views/dialog_widgets/dialog_utils.dart';
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

  Future onTapList(int index) async {
    if (index == 0) {
      return DialogUtils.dialogInputNickname();
    }
    if (index == 1) {
      return DialogUtils.dialogDataPicker(
        title: "yours_sex".tr,
        datas: ["man".tr, "woman".tr],
      );
    }
    if (index == 2) {
      return DialogUtils.dialogDataPicker(
        title: "yours_height".tr,
        datas: ListEx.generateHeightArr(),
        symbolText: "cm",
        initialItem: 50,
        symbolRight: 124.w,
      );
    }
    if (index == 3) {
      return DialogUtils.dialogDataPicker(
        title: "youres_weight".tr,
        datas: ListEx.generateWeightArr(),
        symbolText: "kg",
        initialItem: 20,
        symbolRight: 124.w,
      );
    }
  }
}
