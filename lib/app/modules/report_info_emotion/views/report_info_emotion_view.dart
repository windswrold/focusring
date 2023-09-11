import 'package:flutter/material.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/chart_utils.dart';
import 'package:beering/views/charts/home_card/model/home_card_x.dart';
import 'package:beering/views/tra_led_button.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/report_info_emotion_controller.dart';

class ReportInfoEmotionView extends GetView<ReportInfoEmotionController> {
  const ReportInfoEmotionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      hiddenAppBar: true,
      safeAreaTop: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: KHealthDataType.EMOTION.getReportGradient(),
        ),
        child: Column(
          children: [
            getAppBar(
              KHealthDataType.EMOTION.getDisplayName(isReport: true),
            ),
            TraLedButtonView(),
            _getBigTitle(),
            _buildChart(),
            _getOtherView(),
            NextButton(
              onPressed: () {
                controller.stratTest();
              },
              title: "strat_test".tr,
              margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 20.w),
              textStyle: Get.textTheme.displayLarge,
              height: 44.w,
              gradient: LinearGradient(colors: [
                ColorUtils.fromHex("#FF0E9FF5"),
                ColorUtils.fromHex("#FF02FFE2"),
              ]),
              borderRadius: 22,
            )
          ],
        ),
      ),
    );
  }

  Widget _getBigTitle() {
    return Container(
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
            KHealthDataType.EMOTION.getDisplayName(isReportSmallTotal: true),
            style: Get.textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 280.w,
      padding: EdgeInsets.only(top: 40.w, bottom: 10.w),
      child: Column(
        children: [
          GetX<ReportInfoEmotionController>(builder: (a) {
            return AnimatedOpacity(
              opacity: a.chartTipValue.value.isEmpty ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding:
                    EdgeInsets.only(left: 21.w, right: 21.w, top: 4, bottom: 4),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: KHealthDataType.EMOTION.getTypeMainColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  a.chartTipValue.value,
                  style: Get.textTheme.labelSmall,
                ),
              ),
            );
          }),
          GetBuilder<ReportInfoEmotionController>(
            id: ReportInfoEmotionController.id_data_souce_update,
            builder: (a) {
              return Expanded(
                child: SfCartesianChart(
                  plotAreaBorderWidth: controller.allResult.isEmpty ? 0 : 0,
                  margin: const EdgeInsets.only(left: 5, right: 10),
                  primaryXAxis: ChartUtils.getCategoryAxis(),
                  primaryYAxis: CategoryAxis(isVisible: false),
                  onTrackballPositionChanging: (trackballArgs) {
                    vmPrint("onTrackballPositionChanging" +
                        trackballArgs.chartPointInfo.dataPointIndex.toString());
                    a.onTrackballPositionChanging(
                        trackballArgs.chartPointInfo.dataPointIndex);
                  },
                  series: ChartUtils.getChartReportServices(
                    datas: a.dataSource,
                    type: KHealthDataType.EMOTION,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getOtherView() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                LoadAssetsImage(
                  "icons/report_icon_emotion",
                  width: 32,
                  height: 32,
                ),
                10.rowWidget,
                Text(
                  "eMOTION_status".tr,
                  style: Get.textTheme.displayLarge,
                ),
              ],
            ),
            _buildItem(type: KEMOTIONStatusType.positive, value: "-"),
            _buildItem(type: KEMOTIONStatusType.neutral, value: "-"),
            _buildItem(type: KEMOTIONStatusType.negative, value: "-"),
          ],
        ));
  }

  Widget _buildItem({required KEMOTIONStatusType type, required String value}) {
    return Container(
      margin: EdgeInsets.only(top: 12.w),
      child: Row(
        children: [
          Container(
            width: 70.w,
            child: Text(
              type.getStatusDesc(),
              style: Get.textTheme.displayLarge,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0,
                color: type.getStatusColor(),
                backgroundColor: ColorUtils.fromHex("#FF232126"),
                minHeight: 8,
              ),
            ),
          ),
          10.rowWidget,
          Text(
            value,
            style: Get.textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}
