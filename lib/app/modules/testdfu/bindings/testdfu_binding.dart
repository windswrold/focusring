import 'package:get/get.dart';

import '../controllers/testdfu_controller.dart';

class TestdfuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestdfuController>(
      () => TestdfuController(),
    );
  }
}
