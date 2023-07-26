import 'package:get/get.dart';

import '../controllers/faq_info_view_controller.dart';

class FaqInfoViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqInfoViewController>(
      () => FaqInfoViewController(),
    );
  }
}
