import 'package:get/get.dart';

import '../controllers/home_edit_card_controller.dart';

class HomeEditCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeEditCardController>(
      () => HomeEditCardController(),
    );
  }
}
