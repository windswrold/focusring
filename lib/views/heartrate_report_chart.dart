import 'dart:math';

import 'package:focusring/app/modules/report_info_steps/controllers/report_info_steps_controller.dart';
import 'package:focusring/utils/chart_utils.dart';
import 'package:focusring/utils/custom_segment_render.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/report_footer.dart';
import 'package:focusring/views/today_overview.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../public.dart';

class HeartChartReportChart extends StatelessWidget {
  const HeartChartReportChart({Key? key, required this.pageType})
      : super(key: key);

  final KReportType pageType;

  Widget _buildChart() {
    return Container(
      height: 280.w,
      padding: EdgeInsets.only(top: 40.w, bottom: 10.w),
      child: Column(
        children: [
          GetX<ReportInfoStepsController>(builder: (a) {
            return AnimatedOpacity(
              opacity: a.chartTipValue.value.isEmpty ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding:
                    EdgeInsets.only(left: 21.w, right: 21.w, top: 4, bottom: 4),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: KHealthDataType.HEART_RATE.getTypeMainColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  a.chartTipValue.value,
                  style: Get.textTheme.labelSmall,
                ),
              ),
            );
          }),
          GetBuilder<ReportInfoStepsController>(
            id: ReportInfoStepsController.id_data_souce_update,
            builder: (a) {
              return Expanded(
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  margin: const EdgeInsets.only(left: 5, right: 10),
                  primaryXAxis: ChartUtils.getCategoryAxis(),
                  primaryYAxis: ChartUtils.getNumericAxis(),
                  trackballBehavior: ChartUtils.getTrackballBehavior(
                    color: KHealthDataType.HEART_RATE.getTypeMainColor()!,
                  ),
                  onTrackballPositionChanging: (trackballArgs) {
                    vmPrint("onTrackballPositionChanging" +
                        trackballArgs.chartPointInfo.dataPointIndex.toString());
                    a.onTrackballPositionChanging(
                        trackballArgs.chartPointInfo.dataPointIndex);
                  },
                  series: ChartUtils.getChartReportServices(
                      datas: a.dataSource,
                      type: KHealthDataType.HEART_RATE,
                      reportType: pageType),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildChart(),
        Container(
          margin: EdgeInsets.only(left: 12.w, right: 12.w),
          child: TodayOverView(
            datas: [
              TodayOverViewModel(title: "resting_heartrate".tr, content: "1"),
              TodayOverViewModel(title: "max_heartrate".tr, content: "2"),
              TodayOverViewModel(title: "min_heartrate".tr, content: "3"),
            ],
            type: pageType,
          ),
        ),
        pageType == KReportType.day ? _getDay() : Container(),
        const ReportFooter(
          type: KHealthDataType.HEART_RATE,
        ),
      ],
    );
  }

  Widget _getTitle() {
    return Row(
      children: [
        LoadAssetsImage(
          "icons/status_card_icon_hr",
          width: 35,
          height: 35,
        ),
        8.rowWidget,
        Text(
          "heartrate_subtype".tr,
          style: Get.textTheme.displayLarge,
        ),
      ],
    );
  }

  Widget _getDay() {
    Widget _builditem(KHeartRateStatus status, String value) {
      return Container(
        margin: EdgeInsets.only(bottom: 11.w),
        child: Row(
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: status.getStatusColor(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12.w),
              child: Text(
                status.getStatusDesc() + status.getStateCondition(status),
                style: Get.textTheme.displayLarge,
              ),
            ),
            Expanded(child: Container()),
            Container(
              child: Text(
                value,
                style: Get.textTheme.displayLarge,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.w),
      margin: EdgeInsets.only(top: 12.w, left: 12.w, right: 12.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _getTitle(),
          Container(
            height: 170.w,
            width: 170.w,
            child: SfCircularChart(
              series: [
                DoughnutSeries<KChartCellData, String>(
                  radius: '100%',
                  selectionBehavior: SelectionBehavior(enable: false),
                  dataSource: <KChartCellData>[
                    KChartCellData(
                      x: 'Chlorine',
                      y: 55,
                    ),
                    KChartCellData(
                      x: 'Sodium',
                      y: 31,
                    ),
                    KChartCellData(x: 'Magnesium', y: 7.7),
                    KChartCellData(
                      x: 'Sulfur',
                      y: 3.7,
                    ),
                    KChartCellData(
                      x: 'Calcium',
                      y: 1.2,
                    ),
                    KChartCellData(
                      x: 'Others',
                      y: 1.4,
                    ),
                  ],
                  xValueMapper: (KChartCellData data, _) => data.x as String,
                  yValueMapper: (KChartCellData data, _) => data.y,
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25.w, left: 12.w, right: 12.w),
            child: Column(
              children: KHeartRateStatus.values
                  .map((e) => _builditem(e, "value"))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
