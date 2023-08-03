import 'dart:math';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:focusring/theme/theme.dart';
import 'package:focusring/views/bloodoxygen_report_chart.dart';
import 'package:focusring/views/body_temperature_report_chart.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/charts/progress_chart.dart';
import 'package:focusring/views/heartrate_report_chart.dart';
import 'package:focusring/views/sleep_time_report_chart.dart';
import 'package:focusring/views/steps_licheng_report_chart.dart';
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

  Widget _getBigTitle() {
    return Visibility(
        visible: (controller.currentType != KHealthDataType.SLEEP),
        child: Container(
          margin: EdgeInsets.only(top: 10.w),
          child: Column(
            children: [
              Obx(
                () => Text(
                  controller.allResult.value,
                  style: Get.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
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

  Widget _getPageViewWidget(KReportType pageType) {
    return SingleChildScrollView(
      child: _buildChart(pageType),
    );
  }

  Widget _buildChart(KReportType pageType) {
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
      return StepsLiChengReportChart(
        pageType: pageType,
        type: controller.currentType,
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
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
              TraLedButton(),
              _getBigTitle(),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.tabController,
                  children: [
                    // ReportInfoChildView(
                    //     currentType: controller.currentType,
                    //     pageType: KReportType.day),
                    // ReportInfoChildView(
                    //     currentType: controller.currentType,
                    //     pageType: KReportType.week),
                    // ReportInfoChildView(
                    //     currentType: controller.currentType,
                    //     pageType: KReportType.moneth),

                    _getPageViewWidget(KReportType.day),
                    _getPageViewWidget(KReportType.week),
                    _getPageViewWidget(KReportType.moneth),
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

class ReportInfoChildView extends StatefulWidget {
  ReportInfoChildView(
      {Key? key, required this.currentType, required this.pageType})
      : super(key: key);

  final KHealthDataType currentType;
  final KReportType pageType;

  @override
  State<ReportInfoChildView> createState() => _ReportInfoChildViewState();
}

class _ReportInfoChildViewState extends State<ReportInfoChildView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    vmPrint("_ReportInfoChildViewState");
    return SingleChildScrollView(
      child: _buildChart(widget.pageType),
    );
  }

  Widget _buildChart(KReportType pageType) {
    if (widget.currentType == KHealthDataType.SLEEP) {
      return SleepTimeReportChart(pageType: pageType);
    }
    if (widget.currentType == KHealthDataType.HEART_RATE) {
      return HeartChartReportChart(pageType: pageType);
    }
    if (widget.currentType == KHealthDataType.BLOOD_OXYGEN) {
      return BloodOxygenReportChart(pageType: pageType);
    }

    if (widget.currentType == KHealthDataType.BODY_TEMPERATURE) {
      return BodyTemperatureReportChart(pageType: pageType);
    }

    if (widget.currentType == KHealthDataType.STEPS ||
        widget.currentType == KHealthDataType.LiCheng ||
        widget.currentType == KHealthDataType.CALORIES_BURNED) {
      return StepsLiChengReportChart(
        pageType: pageType,
        type: widget.currentType,
      );
    }

    return Container();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
