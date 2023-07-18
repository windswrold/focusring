import 'package:flutter/material.dart';
import 'package:focusring/public.dart';

import 'package:get/get.dart';

import '../controllers/setting_user_info_controller.dart';

class SettingUserInfoView extends GetView<SettingUserInfoController> {
  const SettingUserInfoView({Key? key}) : super(key: key);

  Widget _getListItem({
    required int index,
    required String title,
    required String value,
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
            Text(
              title.tr,
              style: Get.textTheme.displayLarge,
            ),
            Row(
              children: [
                Text(
                  value,
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
      titleStr: "setting_userinfo".tr,
      body: IntrinsicHeight(
        child: Container(
          margin: EdgeInsets.only(left: 14.w, top: 14.w, right: 14.w),
          decoration: BoxDecoration(
            color: ColorUtils.fromHex("#FF000000"),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              _getListItem(index: 0, title: "nickname".tr, value: "1"),
              _getListItem(index: 1, title: "sex".tr, value: "1"),
              _getListItem(index: 2, title: "person_height".tr, value: "1"),
              _getListItem(index: 3, title: "weight".tr, value: "1"),
            ],
          ),
        ),
      ),
    );
  }
}
