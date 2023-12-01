import 'package:beering/app/modules/home_state/controllers/home_state_controller.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/sp_manager.dart';
import 'package:get/get.dart';

import '../../app_view/controllers/app_view_controller.dart';

class LoginViewController extends GetxController {
  //TODO: Implement LoginViewController

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapLogin() async {
    AppApi.visitorLoginStream(onSuccess: (value) {
      final app = Get.find<AppViewController>(tag: AppViewController.tag);
      app.user = value.obs;
      app.update([AppViewController.userinfoID]);
      Get.offNamed(Routes.HOME_TABBAR);

      final vc = Get.find<HomeStateController>();
      vc.initData();

    }, onError: (r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }
}
