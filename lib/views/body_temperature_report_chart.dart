import 'dart:math';

import 'package:focusring/utils/chart_utils.dart';
import 'package:focusring/views/report_footer.dart';
import 'package:focusring/views/today_overview.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../public.dart';
import 'charts/home_card/model/home_card_x.dart';

class BodyTemperatureReportChart extends StatelessWidget {
  const BodyTemperatureReportChart({Key? key, required this.pageType})
      : super(key: key);

  final KReportType pageType;

  Widget _buildDay() {
    return SfCartesianChart(
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
        ScatterSeries<KChartCellData, String>(
          dataSource: List.generate(
              30, (index) => KChartCellData(x: "$index", y: index.toDouble())),
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.y,
          markerSettings: const MarkerSettings(
            height: 3,
            width: 3,
          ),
          pointColorMapper: (datum, index) => Colors.red,
        ),
      ],
    );
  }

  Widget _buildWeek() {
    var data = List.generate(
        30,
        (index) => KChartCellData(
            x: index.toString(), y: Random.secure().nextInt(1000)));

    return SfCartesianChart(
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
        RangeColumnSeries<KChartCellData, String>(
          dataSource: data,
          xValueMapper: (KChartCellData sales, _) => sales.x,
          lowValueMapper: (KChartCellData sales, _) => sales.y - 200,
          highValueMapper: (KChartCellData sales, _) => sales.y,
        ),
      ],
    );
  }

  Widget _getFooter() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
        margin: EdgeInsets.only(top: 12.w),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "manual_record".tr,
              style: Get.textTheme.displayLarge,
            ),
            LoadAssetsImage(
              "icons/arrow_right_small",
              width: 7,
              height: 12,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 233.w,
          margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 40.w),
          child: pageType == KReportType.day ? _buildDay() : _buildWeek(),
        ),
        Container(
          margin: EdgeInsets.only(left: 12.w, right: 12.w),
          child: TodayOverView(
            datas: [
              TodayOverViewModel(title: "max_bloodoxygen".tr, content: "1"),
              TodayOverViewModel(title: "mininum_bloodoxygen".tr, content: "2"),
              TodayOverViewModel(title: "exception_number".tr, content: "3"),
            ],
            type: pageType,
          ),
        ),
        const ReportFooter(
          type: KHealthDataType.BLOOD_OXYGEN,
        ),
      ],
    );
  }
}
