import 'dart:math';

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

  Widget _buildDay() {
    return Column(
      children: [
        Expanded(
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            margin: EdgeInsets.only(left: 5, right: 10),
            primaryXAxis: ChartUtils.getCategoryAxis(),
            primaryYAxis: ChartUtils.getNumericAxis(),
            onSelectionChanged: (selectionArgs) {
              vmPrint(
                  "onSelectionChanged" + selectionArgs.seriesIndex.toString());
            },
            trackballBehavior: ChartUtils.getTrackballBehavior(
              color: KHealthDataType.STEPS.getTypeMainColor()!,
            ),
            onTrackballPositionChanging: (trackballArgs) {
              vmPrint("onTrackballPositionChanging" +
                  trackballArgs.chartPointInfo.dataPointIndex.toString());
            },
            series: [
              SplineAreaSeries<KChartCellData, String>(
                dataSource: List.generate(
                    30,
                    (index) => KChartCellData(
                        x: index.toString(), y: Random.secure().nextInt(1000))),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    // mySnTheme.titleColorReverse.withOpacity(0.6),
                    Colors.red,
                    Colors.transparent
                  ],
                ),
                borderWidth: 2,
                xValueMapper: (KChartCellData sales, _) => sales.x,
                yValueMapper: (KChartCellData sales, _) => sales.y,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeek() {
    final a = Random.secure().nextInt(400);
    var data = List.generate(
      30,
      (index) => KChartCellData(
        x: index.toString(),
        y: a,
        z: a + Random.secure().nextInt(200),
        a: a + Random.secure().nextInt(100),
      ),
    );

    return Column(
      children: [
        Expanded(
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            margin: EdgeInsets.only(left: 5, right: 10),
            primaryXAxis: ChartUtils.getCategoryAxis(),
            primaryYAxis: ChartUtils.getNumericAxis(),
            onSelectionChanged: (selectionArgs) {
              vmPrint(
                  "onSelectionChanged" + selectionArgs.seriesIndex.toString());
            },
            trackballBehavior: ChartUtils.getTrackballBehavior(
              color: KHealthDataType.HEART_RATE.getTypeMainColor()!,
            ),
            onTrackballPositionChanging: (trackballArgs) {
              vmPrint("onTrackballPositionChanging" +
                  trackballArgs.chartPointInfo.dataPointIndex.toString());
            },
            series: [
              RangeColumnSeries<KChartCellData, String>(
                dataSource: data,
                xValueMapper: (KChartCellData sales, _) => sales.x,
                highValueMapper: (KChartCellData sales, _) => sales.z,
                lowValueMapper: (KChartCellData sales, _) => sales.y,
                onCreateRenderer: (ChartSeries<dynamic, dynamic> series) {
                  return CustomRangeColumnRenderer(data);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 278.w,
          padding: EdgeInsets.only(top: 40.w),
          child: pageType == KReportType.day ? _buildDay() : _buildWeek(),
        ),
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
