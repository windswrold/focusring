import 'package:get/get.dart';

import '../controllers/language_unit_controller.dart';

class LanguageUnitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageUnitController>(
      () => LanguageUnitController(),
    );
  }
}
