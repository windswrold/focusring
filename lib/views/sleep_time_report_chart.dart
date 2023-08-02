import 'dart:math';

import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../public.dart';

class SleepTimeReportChart extends StatelessWidget {
  const SleepTimeReportChart(
      {Key? key,
      this.sleepTimeSecond,
      this.wakeTimeSecond,
      this.sleepTime,
      required this.pageType})
      : super(key: key);

  final double? sleepTimeSecond;
  final double? wakeTimeSecond;
  final TimeOfDay? sleepTime;
  final KReportType pageType;

  Widget _getDayChart() {
    const thickness = 0.15;
    const maximum = 12.0;
    return Column(
      children: [
        Expanded(
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                axisLineStyle: const AxisLineStyle(
                  thickness: thickness + 0.05,
                  thicknessUnit: GaugeSizeUnit.factor,
                  color: Colors.transparent,
                ),
                minorTicksPerInterval: 15, //间隔
                majorTickStyle: MajorTickStyle(
                  color: ColorUtils.fromHex("#FF9EA3AE"),
                  length: 6,
                ),
                minorTickStyle: MinorTickStyle(
                  length: 2,
                  color: ColorUtils.fromHex("#FFE5E6EB"),
                ),
                maximum: maximum,
                interval: 3,
                startAngle: 270,
                endAngle: 270,
                radiusFactor: 1,
                onLabelCreated: (AxisLabelCreatedArgs args) {
                  if (args.text == "0") {
                    args.text = "12";
                  }
                  args.labelStyle = GaugeTextStyle(
                    fontFamily: fontFamilyRoboto,
                    fontSize: 10.sp,
                    color: ColorUtils.fromHex("#FF9EA3AE"),
                    fontWeight: FontWeight.w400,
                  );
                },
                annotations: <GaugeAnnotation>[
                  //中间子
                  GaugeAnnotation(
                    axisValue: 0,
                    widget: Container(
                      child: sleepTime == null
                          ? null
                          : RichText(
                              text: TextSpan(
                                text: sleepTime?.hour.toString(),
                                style: Get.textTheme.titleLarge,
                                children: [
                                  TextSpan(
                                      text: "h",
                                      style: Get.textTheme.bodyMedium
                                          ?.copyWith(fontSize: 16.sp)),
                                  TextSpan(
                                    text: sleepTime?.minute.toString(),
                                    style: Get.textTheme.titleLarge,
                                  ),
                                  TextSpan(
                                    text: "min",
                                    style: Get.textTheme.bodyMedium
                                        ?.copyWith(fontSize: 16.sp),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
                ranges: [
                  GaugeRange(
                    startValue: 0,
                    endValue: maximum,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: ColorUtils.fromHex("#FF232126"),
                    startWidth: thickness,
                    endWidth: thickness,
                  ),
                  GaugeRange(
                    startValue: sleepTimeSecond ?? 0,
                    endValue: wakeTimeSecond ?? 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: ColorUtils.fromHex("#FF766AFF"),
                    startWidth: thickness,
                    endWidth: thickness,
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 25.w, bottom: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "sleep_time".tr,
                    style: Get.textTheme.bodyMedium,
                  ),
                  11.columnWidget,
                  Row(
                    children: [
                      LoadAssetsImage(
                        "icons/sleep_icon_bedtime",
                        width: 13,
                        height: 13,
                      ),
                      5.rowWidget,
                      Text(
                        "result",
                        style: Get.textTheme.displayLarge,
                      ),
                    ],
                  )
                ],
              ),
              115.rowWidget,
              Column(
                children: [
                  Text(
                    "wakeup_time".tr,
                    style: Get.textTheme.bodyMedium,
                  ),
                  11.columnWidget,
                  Row(
                    children: [
                      LoadAssetsImage(
                        "icons/sleep_icon_wakeup",
                        width: 13,
                        height: 13,
                      ),
                      5.rowWidget,
                      Text(
                        "result",
                        style: Get.textTheme.displayLarge,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getWeekChart() {
    return SfCartesianChart(
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
        tooltipSettings: InteractiveTooltip(
            // borderColor: Colors.blue, // 设置浮动球的边框颜色
            // color: Colors.blue, // 设置浮动球的填充颜色
            // borderRadius: BorderRadius.circular(8), // 设置浮动球的圆角半径
            // elevation: 2,
            ),
      ),
      series: [
        StackedColumnSeries<KChartCellData, String>(
          dataSource: List.generate(
              30,
              (index) => KChartCellData(
                    x: "$index",
                    y: Random.secure().nextInt(40),
                  )),
          isTrackVisible: false,
          spacing: 0,
          borderRadius: BorderRadius.zero,
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.y,
          pointColorMapper: (datum, index) => Colors.red,
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
          onPointTap: (pointInteractionDetails) {
            vmPrint(pointInteractionDetails.seriesIndex);
          },
        ),
        StackedColumnSeries<KChartCellData, String>(
          dataSource: List.generate(
              30,
              (index) => KChartCellData(
                    x: "$index",
                    y: Random.secure().nextInt(40),
                  )),
          isTrackVisible: false,
          spacing: 0,
          borderRadius: BorderRadius.zero,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 283.w,
      padding: EdgeInsets.only(top: 20.w),
      child: pageType == KReportType.day ? _getDayChart() : _getWeekChart(),
    );
  }
}
