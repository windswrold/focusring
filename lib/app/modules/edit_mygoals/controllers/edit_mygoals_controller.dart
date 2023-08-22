import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/console_logger.dart';
import 'package:beering/views/dialog_widgets/controllers/dialog_modify_goals_controller.dart';
import 'package:get/get.dart';

class EditMygoalsController extends GetxController {
  //TODO: Implement EditMygoalsController

  RxList my_defaultList = [].obs;

  @override
  void onInit() {
    super.onInit();

    AppViewController app = Get.find(tag: AppViewController.tag);

    my_defaultList = [
      {
        "a": "icons/target_icon_steps",
        "b": "steps_goals",
        "t": KHealthDataType.STEPS,
        "v": app.user?.value?.stepsPlan
      },
      {
        "a": "icons/target_icon_distance",
        "b": "mileage_goals",
        "t": KHealthDataType.LiCheng,
        "v": app.user?.value?.distancePlan
      },
      {
        "a": "icons/target_icon_calories",
        "b": "activity_goals",
        "t": KHealthDataType.CALORIES_BURNED,
        "v": app.user?.value?.caloriePlan
      },
      {
        "a": "icons/target_icon_sleep",
        "b": "sleep_goals",
        "t": KHealthDataType.SLEEP,
        "v": app.user?.value?.sleepPlan
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

  void onTapList(int index) async {
    var t = my_defaultList[index]["t"];
    var v = my_defaultList[index]["v"];
    var a = DialogModifyGoalsController(currentValue: v, type: t);
    Get.replace(a);
    var result = await DialogUtils.dialogModifyGoals();
    if (result == null) {
      return;
    }
    var item = my_defaultList[index];
    item["v"] = result;
    update();
    requestData();
  }

  void requestData() {
    Map<String, dynamic> params = {
      "stepsPlan": my_defaultList[0]["v"],
      "caloriePlan": my_defaultList[2]["v"],
      "distancePlan": my_defaultList[1]["v"],
      "sleepPlan": my_defaultList[3]["v"],
    };
    HWToast.showLoading();
    AppApi.editUserInfoStream(model: params).onSuccess((value) {
      HWToast.showSucText(text: "modify_success".tr);
      Get.backDelay();
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }
}
