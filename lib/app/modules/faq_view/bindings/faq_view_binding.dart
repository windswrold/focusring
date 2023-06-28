import 'package:get/get.dart';

import '../controllers/faq_view_controller.dart';

class FaqViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqViewController>(
      () => FaqViewController(),
    );
  }
}
