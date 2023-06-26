import 'package:get/get.dart';

import '../controllers/edit_mygoals_controller.dart';

class EditMygoalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditMygoalsController>(
      () => EditMygoalsController(),
    );
  }
}
