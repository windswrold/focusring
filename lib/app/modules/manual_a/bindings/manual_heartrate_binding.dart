import 'package:get/get.dart';

import '../controllers/manual_heartrate_controller.dart';

class ManualHeartrateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManualHeartrateController>(
      () => ManualHeartrateController(),
    );
  }
}
