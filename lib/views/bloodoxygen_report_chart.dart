import 'dart:math';

import 'package:focusring/utils/custom_segment_render.dart';
import 'package:focusring/views/heartrate_report_chart.dart';
import 'package:focusring/views/today_overview.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../public.dart';
import 'charts/home_card/model/home_card_x.dart';

class BloodOxygenReportChart extends StatelessWidget {
  const BloodOxygenReportChart({Key? key, required this.pageType})
      : super(key: key);

  final int pageType;

  Widget _buildDay() {
    return Container(
        height: 283.w,
        padding: EdgeInsets.only(top: 20.w),
        child: Column(
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
                  ScatterSeries<HomeCardItemModel, String>(
                    dataSource: List.generate(
                        30,
                        (index) => HomeCardItemModel(
                            x: "$index", y: index.toDouble())),
                    xValueMapper: (HomeCardItemModel sales, _) => sales.x,
                    yValueMapper: (HomeCardItemModel sales, _) => sales.y,
                    markerSettings: const MarkerSettings(
                      height: 3,
                      width: 3,
                    ),
                    pointColorMapper: (datum, index) => Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildWeek() {
    var data = List.generate(
        30,
        (index) => HomeCardItemModel(
            x: index.toString(), y: Random.secure().nextInt(1000)));

    return Container(
      height: 283.w,
      padding: EdgeInsets.only(top: 20.w),
      child: Column(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 0.w),
      child: Column(
        children: [
          pageType == 0 ? _buildDay() : _buildWeek(),
          TodayOverView(datas: [
            TodayOverViewModel(title: "max_bloodoxygen".tr, content: "1"),
            TodayOverViewModel(title: "mininum_bloodoxygen".tr, content: "2"),
            TodayOverViewModel(title: "exception_number".tr, content: "3"),
          ]),
        ],
      ),
    );
  }
}
