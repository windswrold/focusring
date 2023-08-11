import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:focusring/app/data/card_health_index.dart';
import 'package:focusring/app/data/user_info.dart';
import 'package:focusring/app/modules/home_state/controllers/home_state_controller.dart';
import 'package:focusring/app/routes/app_pages.dart';
import 'package:focusring/const/constant.dart';
import 'package:focusring/net/app_api.dart';
import 'package:focusring/utils/console_logger.dart';
import 'package:focusring/utils/custom_toast.dart';
import 'package:focusring/utils/permission.dart';
import 'package:focusring/utils/sp_manager.dart';
import 'package:get/get.dart';

class AppViewController extends GetxController {
  //TODO: Implement AppViewController

  static String tag = "AppViewControllerTag";

  static String userinfoID = "appviewinfoid";

  Rx<UserInfo?> user = null.obs;

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

    final datas = await KHealthIndexModel.queryAll(id);
    if (datas.isEmpty) {
      KHealthIndexModel.insertTokens(KHealthIndexModel.defaultList(id));
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
