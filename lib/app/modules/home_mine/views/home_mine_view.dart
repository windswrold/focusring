import 'package:flutter/material.dart';
import 'package:focusring/public.dart';
import 'package:focusring/views/base/base_pageview.dart';

import 'package:get/get.dart';

import '../controllers/home_mine_controller.dart';

class HomeMineView extends GetView<HomeMineController> {
  const HomeMineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      leading: Container(
        margin: EdgeInsets.only(left: 16.w),
        alignment: Alignment.centerLeft,
        width: 200.w,
        child: Text(
          "未登录",
          style: Get.textTheme.titleLarge,
          maxLines: 1,
        ),
      ),
      leadingWidth: 200.w,
      actions: [
        IconButton(
          onPressed: () {
            controller.onTapSetting();
          },
          icon: LoadAssetsImage(
            "icons/mine_icon_setting",
            width: 27,
            height: 27,
          ),
        )
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 12.w, right: 12.w),
              height: 208.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorUtils.fromHex("#FF000000"),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  InkWell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16.w, right: 16.w),
                      height: 44.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "my_goals".tr,
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
                  ),
                  Wrap(
                    runSpacing: 12.w,
                    spacing: 12.w,
                    children: [
                      _getCardItem(
                          bgIcon: "icons/mine_stepstarget_bg",
                          cardIcon: "icons/mine_icon_steps",
                          type: KHealthDataType.STEPS.getDisplayName(),
                          value: "value"),
                      _getCardItem(
                          bgIcon: "icons/mine_distancetarget_bg",
                          cardIcon: "icons/mine_icon_distance",
                          type: KHealthDataType.DISTANCE.getDisplayName(),
                          value: "value"),
                      _getCardItem(
                          bgIcon: "icons/mine_caroliestarget_bg",
                          cardIcon: "icons/mine_icon_calories",
                          type:
                              KHealthDataType.CALORIES_BURNED.getDisplayName(),
                          value: "value"),
                      _getCardItem(
                          bgIcon: "icons/mine_sleeptarget_bg",
                          cardIcon: "icons/mine_icon_sleep",
                          type: KHealthDataType.SLEEP.getDisplayName(),
                          value: "value"),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 352.w,
              margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.w),
              padding: EdgeInsets.only(top: 16.w),
              decoration: BoxDecoration(
                color: ColorUtils.fromHex("#FF000000"),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: controller.my_defaultList
                    .map((element) => _getListItem(
                        index: controller.my_defaultList.indexOf(element),
                        icon: element["a"],
                        title: element["b"]))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                LoadAssetsImage(
                  icon,
                  width: 40,
                  height: 40,
                ),
                12.rowWidget,
                Text(
                  title,
                  style: Get.textTheme.displayLarge,
                ),
              ],
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

  Widget _getCardItem({
    required String bgIcon,
    required String cardIcon,
    required String type,
    required String value,
  }) {
    return Container(
      height: 70.w,
      width: 157.w,
      padding: EdgeInsets.only(left: 20.w, right: 10.w),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("$assetsImages$bgIcon@3x.png"),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LoadAssetsImage(
            cardIcon,
            width: 40,
            height: 40,
          ),
          12.rowWidget,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  type,
                  style: Get.textTheme.displayLarge,
                ),
                4.columnWidget,
                Text(
                  value,
                  style: Get.textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
