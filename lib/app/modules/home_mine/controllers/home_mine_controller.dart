import 'package:beering/app/routes/app_pages.dart';
import 'package:beering/generated/locales.g.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/console_logger.dart';
import 'package:beering/views/dialog_widgets/controllers/dialog_modify_goals_controller.dart';
import 'package:get/get.dart';

class HomeMineController extends GetxController {
  //TODO: Implement HomeMineController

  final count = 0.obs;

  RxList my_goalsList = [].obs;

  RxList my_defaultList = [].obs;

  @override
  void onInit() {
    super.onInit();

    my_defaultList = [
      {
        "a": "icons/mine_icon_unit",
        "b": "unit_settings",
        "r": Routes.UNIT_SYSTEM
      },
      // {
      //   "a": "icons/mine_icon_account",
      //   "b": "AccountSecurity",
      //   "r": "",
      // },
      {
        "a": "icons/mine_icon_language",
        "b": "language",
        "r": Routes.LANGUAGE_UNIT,
      },
      {
        "a": "icons/mine_icon_feedback",
        "b": "Feedback",
        "r": Routes.SETTING_FEEDBACK,
      },
      {
        "a": "icons/mine_icon_faq",
        "b": "FAQ",
        "r": Routes.FAQ_VIEW,
      },
      {
        "a": "icons/mine_icon_about",
        "b": "about",
        "r": Routes.ABOUT_US,
      },
      {
        "a": "icons/mine_icon_about",
        "b": "perferseting",
        "r": Routes.PERMISS_SETTING,
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

  void onTapMyGoals() {
    Get.toNamed(Routes.EDIT_MYGOALS);
  }

  void onTapSetting() {
    Get.toNamed(Routes.SETTING_USER_INFO);
  }

  void onTapList(int index) {
    vmPrint(index);
    String a = my_defaultList[index]["r"];
    if (a.isEmpty) {
      return;
    }
    Get.toNamed(a);
  }
}
