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
                    _buildHeader(),
                    _getFooter(),
                  ],
                ),
              ),
            ),
            NextButton(
              onPressed: () {},
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

  Widget _buildHeader() {
    return Container(
      height: 270.w,
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: EdgeInsets.only(left: 5, right: 10),
        primaryXAxis: ChartUtils.getCategoryAxis(),
        primaryYAxis: ChartUtils.getNumericAxis(),
        onSelectionChanged: (selectionArgs) {
          vmPrint("onSelectionChanged" + selectionArgs.seriesIndex.toString());
        },
        trackballBehavior: ChartUtils.getTrackballBehavior(
          color: KHealthDataType.STEPS.getTypeMainColor()!,
        ),
        onTrackballPositionChanging: (trackballArgs) {
          vmPrint("onTrackballPositionChanging" +
              trackballArgs.chartPointInfo.dataPointIndex.toString());
        },
        series: [
          ColumnSeries<KChartCellData, String>(
            dataSource: List.generate(
                30,
                (index) => KChartCellData(
                    x: "15:$index", y: Random.secure().nextDouble() * 500)),
            isTrackVisible: false,
            borderRadius: BorderRadius.circular(3),
            xValueMapper: (KChartCellData sales, _) => sales.x,
            yValueMapper: (KChartCellData sales, _) => sales.y,
            pointColorMapper: (datum, index) => datum.color,
            dataLabelSettings: const DataLabelSettings(
              isVisible: false,
            ),
            onPointTap: (pointInteractionDetails) {
              vmPrint(pointInteractionDetails.seriesIndex);
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
          _buildItem(title: "max_stress".tr, value: '111'),
          150.rowWidget,
          _buildItem(title: "min_stress".tr, value: "222"),
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
                value: 0.5,
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
          _buildItem(status: KStressStatus.normal, value: 10),
          _buildItem(status: KStressStatus.mild, value: 10),
          _buildItem(status: KStressStatus.moderate, value: 10),
          _buildItem(status: KStressStatus.severe, value: 10),
        ],
      ),
    );
  }
}