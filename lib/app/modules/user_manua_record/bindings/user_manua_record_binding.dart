import 'package:get/get.dart';

import '../controllers/user_manua_record_controller.dart';

class UserManuaRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManuaRecordController>(
      () => UserManuaRecordController(),
    );
  }
}
