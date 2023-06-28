import 'package:get/get.dart';

import '../controllers/unit_system_controller.dart';

class UnitSystemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UnitSystemController>(
      () => UnitSystemController(),
    );
  }
}
