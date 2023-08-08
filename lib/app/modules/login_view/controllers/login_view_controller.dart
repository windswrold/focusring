import 'package:focusring/app/modules/home_state/controllers/home_state_controller.dart';
import 'package:focusring/net/app_api.dart';
import 'package:focusring/public.dart';
import 'package:focusring/utils/sp_manager.dart';
import 'package:get/get.dart';

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
    final id = await SPManager.getPhoneID();
    AppApi.visitorLogin(
      phoneId: id,
      systemType: getSystemType(),
    ).onError((r) {
      HWToast.showErrText(text: r.error ?? "a");
    }).onSuccess((value) {
      Get.offNamed(Routes.HOME_TABBAR);
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }
}
