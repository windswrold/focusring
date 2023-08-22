import 'package:flutter/material.dart';
import 'package:beering/public.dart';

import 'package:get/get.dart';

import '../controllers/login_view_controller.dart';

class LoginViewView extends GetView<LoginViewController> {
  const LoginViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "welecome_to".tr + (GlobalValues.appInfo?.appName ?? ""),
      centerTitle: false,
      hiddenLeading: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NextButton(
            onPressed: () {
              controller.onTapLogin();
            },
            title: "visit_login".tr,
            margin: EdgeInsets.only(left: 12.w, right: 12.w),
            textStyle: Get.textTheme.displayLarge,
            height: 44.w,
            gradient: LinearGradient(colors: [
              ColorUtils.fromHex("#FF0E9FF5"),
              ColorUtils.fromHex("#FF02FFE2"),
            ]),
            borderRadius: 22,
          )
        ],
      ),
    );
  }
}
