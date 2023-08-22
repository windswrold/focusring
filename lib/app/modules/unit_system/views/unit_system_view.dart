import 'package:flutter/material.dart';
import 'package:beering/public.dart';

import 'package:get/get.dart';

import '../controllers/unit_system_controller.dart';

class UnitSystemView extends GetView<UnitSystemController> {
  const UnitSystemView({Key? key}) : super(key: key);

  Widget _getListItem({
    required String title,
    required bool isSelect,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        height: 44.w,
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
            child: Obx(
              () => Column(
                children: KUnits.values
                    .map((e) => _getListItem(
                        title: e.title(),
                        isSelect: controller.units.value == e ? true : false,
                        onTap: () {
                          controller.onTapUnit(e);
                        }))
                    .toList(),
              ),
            ),
          ),
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 16.w),
            margin: EdgeInsets.only(top: 12.w, left: 12.w, right: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: ColorUtils.fromHex("#FF000000"),
            ),
            child: Obx(
              () => Column(
                children: KTempUnits.values
                    .map((e) => _getListItem(
                        title: e.title(),
                        isSelect:
                            controller.tempUnits.value == e ? true : false,
                        onTap: () {
                          controller.onTapTempUnit(e);
                        }))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
