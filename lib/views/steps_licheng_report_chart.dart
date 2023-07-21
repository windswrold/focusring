import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../public.dart';

class StepsLiChengReportChart extends StatelessWidget {
  const StepsLiChengReportChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 278.w,
        padding: EdgeInsets.only(top: 40.w, bottom: 10.w),
        child: Column(
          // alignment: Alignment.topCenter,
          children: [
            Offstage(
              offstage: false,
              child: Container(
                height: 25.w,
                width: 154.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text("data"),
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  majorGridLines: MajorGridLines(width: 0), // 设置主要网格线样式
                  minorGridLines: MinorGridLines(width: 0),
                  majorTickLines: MajorTickLines(width: 0),
                  minorTickLines: MinorTickLines(width: 0),
                  axisLine: AxisLine(
                    color: ColorUtils.fromHex("#FF2C2F2F"),
                  ),
                  labelStyle: Get.textTheme.displaySmall,
                ),
                primaryYAxis: NumericAxis(
                  // 设置主要网格线样式
                  majorGridLines: MajorGridLines(
                      dashArray: [1, 2],
                      color: ColorUtils.fromHex("#FF2C2F2F")),
                  minorGridLines: MinorGridLines(width: 0),
                  majorTickLines: MajorTickLines(width: 0),
                  minorTickLines: MinorTickLines(width: 0),
                  axisLine: AxisLine(
                    width: 0,
                  ),
                  labelStyle: Get.textTheme.displaySmall,
                ),
                onSelectionChanged: (selectionArgs) {
                  vmPrint("onSelectionChanged" +
                      selectionArgs.seriesIndex.toString());
                },
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                  tooltipAlignment: ChartAlignment.near,
                  lineColor: ColorUtils.fromHex("#FF34E050").withOpacity(0.5),
                  lineType: TrackballLineType.vertical,
                  lineWidth: 11,
                  shouldAlwaysShow: true,
                  builder: (context, trackballDetails) {
                    return Container();
                  },
                ),
                onTrackballPositionChanging: (trackballArgs) {
                  vmPrint("onTrackballPositionChanging" +
                      trackballArgs.chartPointInfo.dataPointIndex.toString());
                },
                series: <ColumnSeries<KChartCellData, String>>[
                  ColumnSeries<KChartCellData, String>(
                    dataSource: List.generate(
                        30,
                        (index) => KChartCellData(
                            x: "15:$index", y: index.toDouble())),
                    isTrackVisible: false,
                    borderRadius: BorderRadius.circular(3),
                    xValueMapper: (KChartCellData sales, _) => sales.x,
                    yValueMapper: (KChartCellData sales, _) => sales.y,
                    pointColorMapper: (datum, index) => datum.color,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: false,
                    ),
                    onPointTap: (pointInteractionDetails) {
                      vmPrint("onPointTap" +
                          pointInteractionDetails.pointIndex.toString());
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
