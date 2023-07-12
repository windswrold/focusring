import 'dart:math';

import 'package:focusring/utils/custom_segment_render.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import "package:syncfusion_flutter_charts/src/chart/chart_series/series.dart";
import '../public.dart';
import "package:syncfusion_flutter_charts/src/chart/chart_series/series_renderer_properties.dart";

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
              lineType: TrackballLineType.horizontal,
              lineWidth: 11,
              shouldAlwaysShow: true,
              tooltipSettings: InteractiveTooltip(),
            ),
            series: [
              SplineAreaSeries<HomeCardItemModel, String>(
                dataSource: List.generate(
                    30,
                    (index) => HomeCardItemModel(
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
                xValueMapper: (HomeCardItemModel sales, _) => sales.x,
                yValueMapper: (HomeCardItemModel sales, _) => sales.y,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeek() {
    var data = List.generate(
        30,
        (index) => HomeCardItemModel(
            x: index.toString(), y: Random.secure().nextInt(1000)));

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
              lineType: TrackballLineType.horizontal,
              lineWidth: 11,
              shouldAlwaysShow: true,
              tooltipSettings: InteractiveTooltip(),
            ),
            series: [
              CustomRangeColumnSeries<HomeCardItemModel, String>(
                dataSource: data,
                // borderWidth: 2,
                xValueMapper: (HomeCardItemModel sales, _) => sales.x,
                lowValueMapper: (HomeCardItemModel sales, _) => sales.y - 200,
                highValueMapper: (HomeCardItemModel sales, _) => sales.y,
                averageValueMapper: (HomeCardItemModel sales, _) => sales.y,
                // pointColorMapper: (datum, index) => Colors.red,
                // dataLabelSettings: DataLabelSettings(
                //   labelAlignment: ChartDataLabelAlignment.top,
                //   textStyle: const TextStyle(fontSize: 10),
                // ),
                // onCreateRenderer: (ChartSeries<dynamic, dynamic> series) {
                //   return CustomRangeColumnRenderer();
                // },
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
      height: 283.w,
      padding: EdgeInsets.only(top: 20.w),
      child: pageType == 0 ? _buildDay() : _buildWeek(),
    );
  }
}