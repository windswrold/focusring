import 'package:focusring/utils/console_logger.dart';
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
      {"a": "icons/mine_icon_unit", "b": "unit_settings".tr},
      {"a": "icons/mine_icon_account", "b": "AccountSecurity".tr},
      {"a": "icons/mine_icon_language", "b": "language".tr},
      {"a": "icons/mine_icon_feedback", "b": "Feedback".tr},
      {"a": "icons/mine_icon_faq", "b": "FAQ".tr},
      {"a": "icons/mine_icon_about", "b": "about".tr},
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

  void onTapSetting() {}

  void onTapList(int index) {
    vmPrint(index);
  }
}
