import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../public.dart';
import '../controllers/home_devices_controller.dart';

class HomeDevicesView extends GetView<HomeDevicesController> {
  const HomeDevicesView({Key? key}) : super(key: key);

  Widget _getListItem({
    required int index,
    required String icon,
    required String title,
  }) {
    return InkWell(
      onTap: () {
        controller.onTapList(index);
      },
      child: Container(
        padding:
            EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w, top: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                LoadAssetsImage(
                  icon,
                  width: 24,
                  height: 26,
                ),
                18.rowWidget,
                Text(
                  title,
                  style: Get.textTheme.displayLarge,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  title,
                  style: Get.textTheme.bodyMedium,
                ),
                12.rowWidget,
                LoadAssetsImage(
                  "icons/arrow_right_small",
                  width: 7,
                  height: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "aaa",
      hiddenLeading: true,
      body: Center(
        child: Text(
          'HomeDevicesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
