import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:focusring/theme/theme.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/charts/progress_chart.dart';
import 'package:focusring/views/heartrate_report_chart.dart';
import 'package:focusring/views/heartrate_report_subview_chart.dart';
import 'package:focusring/views/sleep_time_report_chart.dart';
import 'package:focusring/views/sleep_time_report_subview_chart.dart';
import 'package:focusring/views/steps_licheng_report_chart.dart';
import 'package:focusring/views/steps_licheng_report_subview_chart.dart';

import 'package:get/get.dart';
import '../../../../public.dart';
import '../controllers/report_info_steps_controller.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ReportInfoStepsView extends GetView<ReportInfoStepsController> {
  const ReportInfoStepsView({Key? key}) : super(key: key);
  Widget _getAppBar() {
    return controller.currentType == KHealthDataType.CALORIES_BURNED
        ? Obx(() => AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 40.w,
              leading: KBasePageView.getBack(() {
                Get.back();
              }),
              centerTitle: true,
              title: Text(
                controller.reportType.value.getCaloriesTitle(),
                style: Get.textTheme.titleLarge,
                textAlign: TextAlign.left,
              ),
            ))
        : AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 40.w,
            leading: KBasePageView.getBack(() {
              Get.back();
            }),
            centerTitle: true,
            title: Text(
              controller.currentType.getDisplayName(isReport: true),
              style: Get.textTheme.titleLarge,
              textAlign: TextAlign.left,
            ),
          );
  }

  Widget _getTabbarTitle() {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(40),
      ),
      child: ButtonsTabBar(
        controller: controller.tabController,
        tabs: controller.myTabbas,
        buttonMargin: EdgeInsets.zero,
        unselectedLabelStyle: Get.theme.tabBarTheme.unselectedLabelStyle,
        labelStyle: Get.theme.tabBarTheme.labelStyle,
        splashColor: Colors.transparent,
        radius: 0,
        labelSpacing: 0,
        itemWidth: 85.w,
        height: 30.w,
        contentPadding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF212526"),
          borderRadius: BorderRadius.circular(40),
        ),
        unselectedDecoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(40),
        ),
        onTap: (a) {
          controller.onTapType(a);
        },
      ),
    );
  }

  Widget _getArrowTitle() {
    return Container(
      margin: EdgeInsets.only(left: 61.w, right: 61.w, top: 12.w),
      child: Row(
        children: [
          NextButton(
            onPressed: () {},
            width: 29,
            height: 29,
            bgImg: assetsImages + "icons/report_arrow_left@3x.png",
            title: "",
          ),
          Expanded(
            child: Text(
              "data",
              textAlign: TextAlign.center,
            ),
          ),
          NextButton(
            onPressed: () {},
            width: 29,
            height: 29,
            bgImg: assetsImages + "icons/report_arrow_right@3x.png",
            title: "",
          ),
        ],
      ),
    );
  }

  Widget _getBigTitle() {
    return Visibility(
        visible: controller.currentType != KHealthDataType.SLEEP,
        child: Container(
          margin: EdgeInsets.only(top: 10.w),
          child: Column(
            children: [
              Text(
                "89000",
                style: Get.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Text(
                controller.currentType.getDisplayName(isReportSmallTotal: true),
                style: Get.textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }

  Widget _getMubiao(int pageType) {
    var day =
        "${controller.currentType.getDisplayName(isMubiao: true)}: 8000${controller.currentType.getSymbol()}";
    var week = "average_completionrate".tr;
    var moneth = "average_completionrate".tr;

    if (controller.currentType == KHealthDataType.HEART_RATE) {
      return Container();
    }

    Color? color = controller.currentType.getTypeMainColor();
    if (pageType == 0) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
        ),
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        height: 60.w,
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              day,
              style: Get.textTheme.displayLarge,
            ),
            Row(
              children: [
                ProgressChart(
                  progressValue: 57,
                  rangePointerColor: color,
                  textColor: color,
                ),
                17.rowWidget,
                LoadAssetsImage(
                  "icons/arrow_right_small",
                  width: 7,
                  height: 12,
                ),
              ],
            ),
          ],
        ),
      );
    } else if (pageType == 1) {
      Widget weeekItem(
          {required double progressValue,
          required Color textColor,
          required String dayNum}) {
        return Column(
          children: [
            ProgressChart(
                progressValue: progressValue,
                textColor: textColor,
                rangePointerColor: textColor),
            4.columnWidget,
            Text(
              dayNum,
              style: Get.textTheme.displaySmall,
            ),
          ],
        );
      }

      return Container(
        padding:
            EdgeInsets.only(left: 12.w, right: 12.w, top: 12.w, bottom: 18.w),
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  week,
                  style: Get.textTheme.displayLarge,
                ),
                Row(
                  children: [
                    Text(
                      "100%",
                      style: Get.textTheme.displayLarge,
                    ),
                    17.rowWidget,
                    LoadAssetsImage(
                      "icons/arrow_right_small",
                      width: 7,
                      height: 12,
                    ),
                  ],
                ),
              ],
            ),
            10.columnWidget,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: KTheme.weekColors
                  .map((e) =>
                      weeekItem(progressValue: 1, textColor: e, dayNum: "1"))
                  .toList(),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      height: 44.w,
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            moneth,
            style: Get.textTheme.displayLarge,
          ),
          Row(
            children: [
              Text(
                "100%",
                style: Get.textTheme.displayLarge,
              ),
              17.rowWidget,
              LoadAssetsImage(
                "icons/arrow_right_small",
                width: 7,
                height: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getSubView(int pageType) {
    if (controller.currentType == KHealthDataType.SLEEP) {
      return SleepTimeSubviewChart(
        pageType: pageType,
      );
    }

    if (controller.currentType == KHealthDataType.HEART_RATE) {
      return HeartrateReportSubviewChart(pageType: pageType);
    }

    return StepsLiChengSubviewChart(
      pageType: pageType,
    );
  }

  Widget _getDesc() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
      margin: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.currentType.getReportDesc(),
            style: Get.textTheme.displayLarge,
          ),
          5.columnWidget,
          Text(
            controller.currentType.getReportDesc(isContent: true),
            style: Get.textTheme.displaySmall,
          ),
        ],
      ),
    );
  }

  Widget _getPageViewWidget(int pageType) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _buildChart(pageType),
            _getMubiao(pageType),
            _getSubView(pageType),
            _getDesc(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(int pageType) {
    if (controller.currentType == KHealthDataType.SLEEP) {
      return SleepTimeReportChart(pageType: pageType);
    }
    if (controller.currentType == KHealthDataType.HEART_RATE) {
      return HeartChartReportChart(pageType: pageType);
    }
    return StepsLiChengReportChart();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.myTabbas.length,
      child: KBasePageView(
        hiddenAppBar: true,
        safeAreaTop: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: controller.currentType.getReportGradient(),
          ),
          child: Column(
            children: [
              _getAppBar(),
              _getTabbarTitle(),
              _getArrowTitle(),
              _getBigTitle(),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller.tabController,
                  children: [
                    _getPageViewWidget(0),
                    _getPageViewWidget(1),
                    _getPageViewWidget(2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
