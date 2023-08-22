import 'package:flutter/material.dart';
import 'package:beering/public.dart';
import 'package:beering/views/base/base_pageview.dart';

import 'package:get/get.dart';

import '../controllers/about_us_controller.dart';

class AboutUsView extends GetView<AboutUsController> {
  const AboutUsView({Key? key}) : super(key: key);

  Widget _getListItem({
    required int index,
    required String title,
  }) {
    return InkWell(
      onTap: () {
        controller.tapList(index);
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
            LoadAssetsImage(
              "icons/arrow_right_small",
              width: 7,
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "about".tr,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 70.w),
            // decoration: BoxDecoration(
            //   color: ColorUtils.fromHex("#FF000000"),
            //   borderRadius: BorderRadius.circular(44),
            // ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(44),
              child: LoadAssetsImage(
                "icons/app_icon",
                width: 88,
                height: 88,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 21.w),
            alignment: Alignment.center,
            child: Text(
              GlobalValues.appInfo?.appName ?? "",
              style: Get.textTheme.bodyLarge,
            ),
          ),
          Container(
            child: Text(
              "v" + (GlobalValues.appInfo?.version ?? ""),
              style: Get.textTheme.bodyMedium,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 14.w, top: 23.w, right: 14.w),
            decoration: BoxDecoration(
              color: ColorUtils.fromHex("#FF000000"),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: controller.my_defaultList
                  .map((element) => _getListItem(
                      index: controller.my_defaultList.indexOf(element),
                      title: element["b"]))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
