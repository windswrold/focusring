import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:beering/app/data/card_health_index.dart';
import 'package:beering/app/data/user_info.dart';
import 'package:beering/app/modules/home_state/controllers/home_state_controller.dart';
import 'package:beering/app/routes/app_pages.dart';
import 'package:beering/const/constant.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/utils/console_logger.dart';
import 'package:beering/utils/custom_toast.dart';
import 'package:beering/utils/permission.dart';
import 'package:beering/utils/sp_manager.dart';
import 'package:get/get.dart';

class AppViewController extends GetxController {
  //TODO: Implement AppViewController

  static String tag = "AppViewControllerTag";

  static String userinfoID = "appviewinfoid";

  Rx<UserInfoModel?> user = null.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    login();
  }

  void login() async {
    final id = await SPManager.getPhoneID();

    final datas = await KBaseHealthType.queryAll(id);
    if (datas.isEmpty) {
      KBaseHealthType.insertTokens(KBaseHealthType.defaultList(id));
    }

    AppApi.visitorLogin(
      phoneId: id,
      systemType: getSystemType(),
    ).onError((r) {
      HWToast.showErrText(text: r.error ?? "a");
    }).onSuccess((value) {
      // user.value = value;
      user = value.obs;
      update([userinfoID]);

      final vc = Get.find<HomeStateController>();
      vc.initData();
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
      Get.offNamed(Routes.LOGIN_VIEW);
    });
  }

  void getUserInfo() async {
    AppApi.getUserInfo().onError((r) {
      HWToast.showErrText(text: r.error ?? "a");
    }).onSuccess((value) {
      user.value = value;
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  void loadUser() {
    user.value = SPManager.getGlobalUser();
  }
}
