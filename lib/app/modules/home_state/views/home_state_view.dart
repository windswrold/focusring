import 'package:flutter/material.dart';
import 'package:focusring/app/modules/home_devices/views/home_devices_view.dart';
import 'package:focusring/public.dart';

import 'package:get/get.dart';

import '../controllers/home_state_controller.dart';

class HomeStateView extends GetView<HomeStateController> {
  const HomeStateView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "home_status".tr,
      centerTitle: false,
      hiddenLeading: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildText(),
            _buildText(),
            _buildText(),
          ],
        ),
      ),
    );
  }

  Widget _buildText() {
    return Container(
      margin: EdgeInsets.only(left: 16.w),
      child: Row(
        children: [
          LoadAssetsImage(
            "icons/status_target_distance",
            width: 20,
            height: 21,
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text("111", style: Get.textTheme.displayMedium),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text("/222", style: Get.textTheme.displaySmall),
          ),
        ],
      ),
    );
  }
}
