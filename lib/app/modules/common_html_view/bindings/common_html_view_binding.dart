import 'package:get/get.dart';

import '../controllers/common_html_view_controller.dart';

class CommonHtmlViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommonHtmlViewController>(
      () => CommonHtmlViewController(),
    );
  }
}
