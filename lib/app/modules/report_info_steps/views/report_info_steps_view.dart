import 'dart:math';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:focusring/theme/theme.dart';
import 'package:focusring/views/bloodoxygen_report_chart.dart';
import 'package:focusring/views/body_temperature_report_chart.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/charts/progress_chart.dart';
import 'package:focusring/views/heartrate_report_chart.dart';
import 'package:focusring/views/heartrate_report_subview_chart.dart';
import 'package:focusring/views/sleep_time_report_chart.dart';
import 'package:focusring/views/sleep_time_report_subview_chart.dart';
import 'package:focusring/views/steps_licheng_report_chart.dart';
import 'package:focusring/views/steps_licheng_report_subview_chart.dart';
import 'package:focusring/views/target_completion_rate.dart';
import 'package:focusring/views/tra_led_button.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../public.dart';
import '../controllers/report_info_steps_controller.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ReportInfoStepsView extends GetView<ReportInfoStepsController> {
  const ReportInfoStepsView({Key? key}) : super(key: key);
  Widget _getAppBar() {
    return controller.currentType == KHealthDataType.CALORIES_BURNED
        ? Obx(() => getAppBar(controller.reportType.value.getCaloriesTitle()))
        : getAppBar(controller.currentType.getDisplayName(isReport: true));
  }

  Widget _getTabbarTitle() {
    if (controller.currentType == KHealthDataType.EMOTION ||
        controller.currentType == KHealthDataType.STRESS ||
        controller.currentType == KHealthDataType.FEMALE_HEALTH) {
      return Container();
    }

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
    if (controller.currentType == KHealthDataType.FEMALE_HEALTH) {
      return Container();
    }
    return TraLedButton();
  }

  Widget _getBigTitle() {
    return Visibility(
        visible: (controller.currentType != KHealthDataType.SLEEP &&
            controller.currentType != KHealthDataType.STRESS &&
            controller.currentType != KHealthDataType.FEMALE_HEALTH),
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

  Widget _getPageViewWidget(int pageType) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _buildChart(pageType),
            _getSubView(pageType),
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
    if (controller.currentType == KHealthDataType.BLOOD_OXYGEN) {
      return BloodOxygenReportChart(pageType: pageType);
    }

    if (controller.currentType == KHealthDataType.BODY_TEMPERATURE) {
      return BodyTemperatureReportChart(pageType: pageType);
    }

    if (controller.currentType == KHealthDataType.STEPS ||
        controller.currentType == KHealthDataType.LiCheng ||
        controller.currentType == KHealthDataType.CALORIES_BURNED) {
      return StepsLiChengReportChart();
    }

    return Container();
  }

  Widget _getSubView(int pageType) {
    if (controller.currentType == KHealthDataType.BLOOD_OXYGEN) {
      return Container();
    }
    if (controller.currentType == KHealthDataType.SLEEP) {
      return SleepTimeSubviewChart(
        pageType: pageType,
      );
    }

    if (controller.currentType == KHealthDataType.HEART_RATE) {
      return HeartrateReportSubviewChart(pageType: pageType);
    }

    if (controller.currentType == KHealthDataType.STEPS ||
        controller.currentType == KHealthDataType.LiCheng ||
        controller.currentType == KHealthDataType.CALORIES_BURNED) {
      return StepsLiChengSubviewChart(
        pageType: pageType,
        type: controller.currentType,
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.currentType == KHealthDataType.FEMALE_HEALTH) {}

    return KBasePageView(
      hiddenAppBar: true,
      safeAreaTop: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: controller.currentType.getReportGradient(),
        ),
        child: DefaultTabController(
          length: controller.myTabbas.length,
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
