import 'package:flutter/material.dart';
import 'package:focusring/public.dart';

import 'package:get/get.dart';

import '../controllers/unit_system_controller.dart';

class UnitSystemView extends GetView<UnitSystemController> {
  const UnitSystemView({Key? key}) : super(key: key);

  Widget _getListItem({
    required int index,
    required String title,
    required bool isSelect,
  }) {
    return InkWell(
      onTap: () {
        controller.onTapList(index);
      },
      child: Container(
        padding:
            EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.w, top: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title.tr,
              style: Get.textTheme.displayLarge,
            ),
            Visibility(
              visible: isSelect,
              child: LoadAssetsImage(
                "icons/language_selected",
                width: 44,
                height: 44,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "unit_settings".tr,
      body: Column(
        children: [
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 16.w),
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: ColorUtils.fromHex("#FF000000"),
            ),
            child: Column(
              children: [
                _getListItem(index: 0, title: "unit_gong".tr, isSelect: true),
                _getListItem(index: 0, title: "unit_inch".tr, isSelect: false),
              ],
            ),
          ),
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 16.w),
            margin: EdgeInsets.only(top: 12.w, left: 12.w, right: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: ColorUtils.fromHex("#FF000000"),
            ),
            child: Column(
              children: [
                _getListItem(
                    index: 0, title: "unit_degreescelsius".tr, isSelect: true),
                _getListItem(
                    index: 0, title: "unit_fahrenheit".tr, isSelect: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
