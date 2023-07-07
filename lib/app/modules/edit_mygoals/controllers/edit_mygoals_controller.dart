import 'package:focusring/public.dart';
import 'package:focusring/utils/console_logger.dart';
import 'package:focusring/views/dialog_widgets/controllers/dialog_modify_goals_controller.dart';
import 'package:get/get.dart';

class EditMygoalsController extends GetxController {
  //TODO: Implement EditMygoalsController

  RxList my_defaultList = [].obs;

  @override
  void onInit() {
    super.onInit();

    my_defaultList = [
      {
        "a": "icons/target_icon_steps",
        "b": "steps_goals",
        "t": KHealthDataType.STEPS
      },
      {
        "a": "icons/target_icon_distance",
        "b": "mileage_goals",
        "t": KHealthDataType.LiCheng
      },
      {
        "a": "icons/target_icon_calories",
        "b": "activity_goals",
        "t": KHealthDataType.CALORIES_BURNED
      },
      {
        "a": "icons/target_icon_sleep",
        "b": "sleep_goals",
        "t": KHealthDataType.SLEEP
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
    var a = DialogModifyGoalsController(currentValue: 6, type: t);
    Get.replace(a);
    var result = await DialogUtils.dialogModifyGoals();
    if (result == null) {
      return;
    }
    vmPrint(result);
  }
}
