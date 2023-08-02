import 'dart:math';

import 'package:focusring/utils/custom_segment_render.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../public.dart';

class HeartChartReportChart extends StatelessWidget {
  const HeartChartReportChart({Key? key, required this.pageType})
      : super(key: key);

  final int pageType;

  Widget _buildDay() {
    return Column(
      children: [
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
              majorGridLines: MajorGridLines(
                  dashArray: [1, 2], color: ColorUtils.fromHex("#FF2C2F2F")),
              minorGridLines: MinorGridLines(width: 0),
              majorTickLines: MajorTickLines(width: 0),
              minorTickLines: MinorTickLines(width: 0),
              axisLine: AxisLine(
                width: 0,
              ),
              labelStyle: Get.textTheme.displaySmall,
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              tooltipPosition: TooltipPosition.auto,
            ),
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipAlignment: ChartAlignment.near,
              markerSettings: TrackballMarkerSettings(
                // markerVisibility: TrackballVisibilityMode.visible,
                width: 8,
                height: 8,
                color: Colors.blue, // 设置标记点的颜色
                borderWidth: 2,
                borderColor: Colors.white,
              ),
              lineColor: ColorUtils.fromHex("#FF34E050").withOpacity(0.5),
              lineType: TrackballLineType.vertical,
              lineWidth: 11,
              shouldAlwaysShow: true,
              tooltipSettings: InteractiveTooltip(),
            ),
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
              majorGridLines: MajorGridLines(
                  dashArray: [1, 2], color: ColorUtils.fromHex("#FF2C2F2F")),
              minorGridLines: MinorGridLines(width: 0),
              majorTickLines: MajorTickLines(width: 0),
              minorTickLines: MinorTickLines(width: 0),
              axisLine: AxisLine(
                width: 0,
              ),
              labelStyle: Get.textTheme.displaySmall,
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              tooltipPosition: TooltipPosition.auto,
            ),
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipAlignment: ChartAlignment.near,
              markerSettings: TrackballMarkerSettings(
                // markerVisibility: TrackballVisibilityMode.visible,
                width: 8,
                height: 8,
                color: Colors.blue, // 设置标记点的颜色
                borderWidth: 2,
                borderColor: Colors.white,
              ),
              lineColor: ColorUtils.fromHex("#FF34E050").withOpacity(0.5),
              lineType: TrackballLineType.vertical,
              lineWidth: 11,
              shouldAlwaysShow: true,
              tooltipSettings: InteractiveTooltip(),
            ),
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
      child: pageType == 0 ? _buildDay() : _buildWeek(),
    );
  }
}
