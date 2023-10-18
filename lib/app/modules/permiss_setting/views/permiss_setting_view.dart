import 'package:beering/public.dart';
import 'package:beering/views/base/base_pageview.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/permiss_setting_controller.dart';

class PermissSettingView extends GetView<PermissSettingController> {
  const PermissSettingView({Key? key}) : super(key: key);

  Widget _getItem({
    required String title,
    required String desc,
    required RxBool state,
    required VoidCallback onTap,
  }) {
    return Container(
        margin: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Obx(
                  () => TextButton(
                    onPressed: onTap,
                    child: Text(
                        state.value == true ? "unauth_ed".tr : "unauth".tr),
                  ),
                ),
              ],
            ),
            Text(desc),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
        titleStr: "perferseting".tr,
        body: Column(
          children: [
            _getItem(
                title: "get_location".tr,
                desc: "${"get_location_01".tr}\n${"get_location_02".tr}",
                state: controller.ble,
                onTap: () {
                  controller.requestLocal();
                }),
          ],
        ));
  }
}
