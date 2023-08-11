import 'dart:math';

import 'package:flutter/material.dart';
import 'package:focusring/public.dart';
import 'package:focusring/utils/chart_utils.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/tra_led_button.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/report_info_stress_controller.dart';

class ReportInfoStressView extends GetView<ReportInfoStressController> {
  const ReportInfoStressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      hiddenAppBar: true,
      safeAreaTop: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: KHealthDataType.STRESS.getReportGradient(),
        ),
        child: Column(
          children: [
            getAppBar(
              KHealthDataType.STRESS.getDisplayName(isReport: true),
            ),
            TraLedButton(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMaxMin(),
                    _buildChart(),
                    _getFooter(),
                  ],
                ),
              ),
            ),
            NextButton(
              onPressed: () {
                controller.stratTest();
              },
              title: "strat_test".tr,
              margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 20.w),
              textStyle: Get.textTheme.displayLarge,
              height: 44.w,
              gradient: LinearGradient(colors: [
                ColorUtils.fromHex("#FF0E9FF5"),
                ColorUtils.fromHex("#FF02FFE2"),
              ]),
              borderRadius: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 280.w,
      padding: EdgeInsets.only(top: 40.w, bottom: 10.w),
      child: Column(
        children: [
          GetX<ReportInfoStressController>(builder: (a) {
            return AnimatedOpacity(
              opacity: a.chartTipValue.value.isEmpty ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding:
                    EdgeInsets.only(left: 21.w, right: 21.w, top: 4, bottom: 4),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: KHealthDataType.STRESS.getTypeMainColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  a.chartTipValue.value,
                  style: Get.textTheme.labelSmall,
                ),
              ),
            );
          }),
          GetBuilder<ReportInfoStressController>(
            id: ReportInfoStressController.id_data_souce_update,
            builder: (a) {
              return Expanded(
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  margin: const EdgeInsets.only(left: 5, right: 10),
                  primaryXAxis: ChartUtils.getCategoryAxis(),
                  primaryYAxis: ChartUtils.getNumericAxis(),
                  trackballBehavior: ChartUtils.getTrackballBehavior(
                    color: KHealthDataType.STRESS.getTypeMainColor()!,
                  ),
                  onTrackballPositionChanging: (trackballArgs) {
                    vmPrint("onTrackballPositionChanging" +
                        trackballArgs.chartPointInfo.dataPointIndex.toString());
                    a.onTrackballPositionChanging(
                        trackballArgs.chartPointInfo.dataPointIndex);
                  },
                  series: ChartUtils.getChartReportServices(
                    datas: a.dataSource,
                    type: KHealthDataType.STRESS,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMaxMin() {
    Widget _buildItem({
      required String title,
      required String value,
    }) {
      return Column(
        children: [
          Text(
            value,
            style: Get.textTheme.headlineSmall,
          ),
          Text(title, style: Get.textTheme.bodyMedium),
        ],
      );
    }

    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildItem(title: "max_stress".tr, value: '-'),
          150.rowWidget,
          _buildItem(title: "min_stress".tr, value: "-"),
        ],
      ),
    );
  }

  Widget _getFooter() {
    Widget _buildItem({
      required KStressStatus status,
      required double value,
    }) {
      return Container(
        margin: EdgeInsets.only(top: 12.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status.getStatusDesc() + status.getStateCondition(status),
                  style: Get.textTheme.displayLarge,
                ),
                Text(
                  "$value",
                  style: Get.textTheme.displayLarge,
                ),
              ],
            ),
            12.columnWidget,
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                color: status.getStatusColor(),
                backgroundColor: ColorUtils.fromHex("#FF232126"),
                minHeight: 8,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
      margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 30.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Row(
            children: [
              LoadAssetsImage(
                "icons/status_card_icon_stress",
                width: 30,
                height: 30,
              ),
              8.rowWidget,
              Text(
                "stress_percent".tr,
                style: Get.textTheme.displayLarge,
              ),
            ],
          ),
          _buildItem(status: KStressStatus.normal, value: 0),
          _buildItem(status: KStressStatus.mild, value: 0),
          _buildItem(status: KStressStatus.moderate, value: 0),
          _buildItem(status: KStressStatus.severe, value: 0),
        ],
      ),
    );
  }
}
