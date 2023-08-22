import 'package:flutter/material.dart';
import 'package:beering/public.dart';

import 'package:get/get.dart';

import '../controllers/edit_mygoals_controller.dart';

class EditMygoalsView extends GetView<EditMygoalsController> {
  const EditMygoalsView({Key? key}) : super(key: key);

  Widget _getListItem({
    required int index,
    required String icon,
    required String title,
    required String content,
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
                  title.tr,
                  style: Get.textTheme.displayLarge,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  content,
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
      titleStr: "edit_mygoals".tr,
      body: IntrinsicHeight(
        child: Container(
          margin: EdgeInsets.only(left: 14.w, top: 14.w, right: 14.w),
          decoration: BoxDecoration(
            color: ColorUtils.fromHex("#FF000000"),
            borderRadius: BorderRadius.circular(14),
          ),
          child: GetBuilder(
              init: controller,
              builder: (_) {
                return Column(
                  children: controller.my_defaultList
                      .map((element) => _getListItem(
                          index: controller.my_defaultList.indexOf(element),
                          icon: element["a"],
                          content: element["v"].toString() +
                              (element["t"] as KHealthDataType).getSymbol(),
                          title: element["b"]))
                      .toList(),
                );
              }),
        ),
      ),
    );
  }
}
