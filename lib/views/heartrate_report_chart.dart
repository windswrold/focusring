import 'dart:math';

import 'package:focusring/utils/chart_utils.dart';
import 'package:focusring/utils/custom_segment_render.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
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
    return Container(
      height: 278.w,
      padding: EdgeInsets.only(top: 40.w),
      child: pageType == KReportType.day ? _buildDay() : _buildWeek(),
    );
  }
}
