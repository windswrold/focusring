import 'package:beering/utils/custom_segment_render.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../public.dart';
import '../views/charts/home_card/model/home_card_x.dart';
import 'package:intl/intl.dart';

class ChartUtils {
  static CategoryAxis getCategoryAxis() {
    return CategoryAxis(
      majorGridLines: const MajorGridLines(width: 0),
      // 设置主要网格线样式
      minorGridLines: const MinorGridLines(width: 0),
      majorTickLines: const MajorTickLines(width: 0),
      minorTickLines: const MinorTickLines(width: 0),

      axisLine: AxisLine(
        color: ColorUtils.fromHex("#FF2C2F2F"),
      ),
      labelStyle: Get.textTheme.displaySmall,
    );
  }

  static NumericAxis getNumericAxis({double? max}) {
    return NumericAxis(
      // 设置主要网格线样式
      majorGridLines: MajorGridLines(
          dashArray: [1, 2], color: ColorUtils.fromHex("#FF2C2F2F")),
      minorGridLines: MinorGridLines(width: 0),
      majorTickLines: MajorTickLines(width: 0),
      minorTickLines: MinorTickLines(width: 0),
      numberFormat: NumberFormat.compact(),
      axisLine: AxisLine(
        width: 0,
      ),
      maximum: max == null ? null : max * 1.1,

      labelStyle: Get.textTheme.displaySmall,
    );
  }

  static TrackballBehavior getTrackballBehavior({required Color color}) {
    return TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipAlignment: ChartAlignment.near,
      lineColor: color.withOpacity(0.5),
      lineType: TrackballLineType.vertical,
      lineWidth: 11,
      shouldAlwaysShow: true,
      builder: (context, trackballDetails) {
        return Container();
      },
    );
  }

  static getDateCellItem({
    required String text,
    required String icon,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            icon,
          ),
        ),
      ),
      child: Text(
        text,
        style: Get.textTheme.labelLarge,
      ),
    );
  }

  static List<ChartSeries> getChartServices(
      {required KHealthDataType type,
      required List<List<KChartCellData>> datas}) {
    if (type == KHealthDataType.STEPS ||
        type == KHealthDataType.LiCheng ||
        type == KHealthDataType.CALORIES_BURNED ||
        type == KHealthDataType.STRESS) {
      return [
        ColumnSeries<KChartCellData, String>(
          dataSource: datas.tryFirst ?? [],
          isTrackVisible: true,
          trackColor: ColorUtils.fromHex("#FF212526"),
          trackBorderWidth: 0,
          borderRadius: BorderRadius.circular(3),
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.yor_low,
          pointColorMapper: (datum, index) => datum.color,
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
        ),
      ];
    } else if (type == KHealthDataType.HEART_RATE) {
      return [
        SplineAreaSeries<KChartCellData, String>(
          dataSource: datas.tryFirst ?? [],
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.transparent],
          ),
          borderWidth: 2,
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.yor_low,
        ),
      ];
    } else if (type == KHealthDataType.BLOOD_OXYGEN ||
        type == KHealthDataType.BODY_TEMPERATURE) {
      return [
        // ColumnSeries<KChartCellData, String>(
        //   // dataSource: List.generate((datas.tryFirst ?? []).length,
        //   //     (index) => KChartCellData(x: index.toString(), y: 0.toDouble())),
        //   dataSource: List.generate(30,
        //       (index) => KChartCellData(x: index.toString(), y: 0.toDouble())),
        //   isTrackVisible: true,
        //   trackColor: ColorUtils.fromHex("#212621"),
        //   borderRadius: BorderRadius.circular(3),
        //   tr
        //   trackBorderWidth: 0,
        //   xValueMapper: (KChartCellData sales, _) => sales.x,
        //   yValueMapper: (KChartCellData sales, _) => 0,
        //   dataLabelSettings: const DataLabelSettings(
        //     isVisible: false,
        //   ),
        // ),
        ScatterSeries<KChartCellData, String>(
          dataSource: datas.tryFirst ?? [],
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.yor_low,
          markerSettings: const MarkerSettings(
            height: 3,
            width: 3,
          ),
          pointColorMapper: (datum, index) => datum.color,
        ),
      ];
    } else if (type == KHealthDataType.EMOTION) {
      return [
        StackedColumnSeries<KChartCellData, String>(
          dataSource: datas[0],
          isTrackVisible: true,
          trackColor: ColorUtils.fromHex("#FF212526"),
          trackBorderWidth: 0,
          spacing: 0,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(3),
            bottomLeft: Radius.circular(3),
          ),
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.yor_low,
          pointColorMapper: (datum, index) =>
              KEMOTIONStatusType.positive.getStatusColor(),
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
          onPointTap: (pointInteractionDetails) {
            vmPrint(pointInteractionDetails.seriesIndex);
          },
        ),
        StackedColumnSeries<KChartCellData, String>(
          dataSource: datas[1],
          isTrackVisible: false,
          spacing: 0,
          borderRadius: BorderRadius.zero,
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.yor_low,
          pointColorMapper: (datum, index) =>
              KEMOTIONStatusType.neutral.getStatusColor(),
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
          onPointTap: (pointInteractionDetails) {
            vmPrint(pointInteractionDetails.seriesIndex);
          },
        ),
        StackedColumnSeries<KChartCellData, String>(
          dataSource: datas[2],
          isTrackVisible: false,
          spacing: 0,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3),
            topRight: Radius.circular(3),
          ),
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.yor_low,
          pointColorMapper: (datum, index) =>
              KEMOTIONStatusType.negative.getStatusColor(),
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
          onPointTap: (pointInteractionDetails) {
            vmPrint(pointInteractionDetails.seriesIndex);
          },
        ),
      ];
    }

    return [];
  }

  static List<ChartSeries> getChartReportServices(
      {required KHealthDataType type,
      required List<List<KChartCellData>> datas,
      KReportType? reportType}) {
    if (type == KHealthDataType.STEPS ||
        type == KHealthDataType.LiCheng ||
        type == KHealthDataType.CALORIES_BURNED ||
        type == KHealthDataType.STRESS) {
      return [
        ColumnSeries<KChartCellData, String>(
          dataSource: datas.tryFirst ?? [],
          isTrackVisible: false,
          borderRadius: BorderRadius.circular(3),
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.yor_low,
          pointColorMapper: (datum, index) => datum.color,
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
        ),
      ];
    } else if (type == KHealthDataType.SLEEP ||
        type == KHealthDataType.EMOTION) {
      return datas.length != 3
          ? []
          : [
              StackedColumnSeries<KChartCellData, String>(
                dataSource: datas[0],
                isTrackVisible: false,
                spacing: 0,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(3),
                  bottomLeft: Radius.circular(3),
                ),
                xValueMapper: (KChartCellData sales, _) => sales.x,
                yValueMapper: (KChartCellData sales, _) => sales.yor_low,
                pointColorMapper: (datum, index) => datum.color,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: false,
                ),
                onPointTap: (pointInteractionDetails) {
                  vmPrint(pointInteractionDetails.seriesIndex);
                },
              ),
              StackedColumnSeries<KChartCellData, String>(
                dataSource: datas[1],
                isTrackVisible: false,
                spacing: 0,
                borderRadius: BorderRadius.zero,
                xValueMapper: (KChartCellData sales, _) => sales.x,
                yValueMapper: (KChartCellData sales, _) => sales.yor_low,
                pointColorMapper: (datum, index) => datum.color,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: false,
                ),
                onPointTap: (pointInteractionDetails) {
                  vmPrint(pointInteractionDetails.seriesIndex);
                },
              ),
              StackedColumnSeries<KChartCellData, String>(
                dataSource: datas[2],
                isTrackVisible: false,
                spacing: 0,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                ),
                xValueMapper: (KChartCellData sales, _) => sales.x,
                yValueMapper: (KChartCellData sales, _) => sales.yor_low,
                pointColorMapper: (datum, index) => datum.color,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: false,
                ),
                onPointTap: (pointInteractionDetails) {
                  vmPrint(pointInteractionDetails.seriesIndex);
                },
              ),
            ];
    } else if (type == KHealthDataType.HEART_RATE) {
      if (reportType == KReportType.day) {
        return [
          SplineAreaSeries<KChartCellData, String>(
            dataSource: datas.tryFirst ?? [],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                KHealthDataType.HEART_RATE.getTypeMainColor()!,
                Colors.transparent,
              ],
            ),
            borderWidth: 2,
            xValueMapper: (KChartCellData sales, _) => sales.x,
            yValueMapper: (KChartCellData sales, _) => sales.yor_low,
          ),
        ];
      }
      return [
        RangeColumnSeries<KChartCellData, String>(
          dataSource: datas.tryFirst ?? [],
          xValueMapper: (KChartCellData sales, _) => sales.x,
          highValueMapper: (KChartCellData sales, _) => sales.high,
          lowValueMapper: (KChartCellData sales, _) => sales.yor_low,
          pointColorMapper: (datum, index) => datum.color,
          onCreateRenderer: (ChartSeries<dynamic, dynamic> series) {
            return CustomRangeColumnRenderer(datas.tryFirst ?? []);
          },
        ),
      ];
    } else if (type == KHealthDataType.BLOOD_OXYGEN ||
        type == KHealthDataType.BODY_TEMPERATURE) {
      if (reportType == KReportType.day) {
        return [
          ScatterSeries<KChartCellData, String>(
            dataSource: datas.tryFirst ?? [],
            xValueMapper: (KChartCellData sales, _) => sales.x,
            yValueMapper: (KChartCellData sales, _) => sales.yor_low,
            markerSettings: const MarkerSettings(
              height: 3,
              width: 3,
            ),
            pointColorMapper: (datum, index) => datum.color,
          ),
        ];
      }

      return [
        RangeColumnSeries<KChartCellData, String>(
          dataSource: datas.tryFirst ?? [],
          xValueMapper: (KChartCellData sales, _) => sales.x,
          highValueMapper: (KChartCellData sales, _) => sales.high,
          lowValueMapper: (KChartCellData sales, _) => sales.yor_low,
          pointColorMapper: (datum, index) => datum.color,
          onCreateRenderer: (ChartSeries<dynamic, dynamic> series) {
            return CustomRangeColumnRenderer(datas.tryFirst ?? []);
          },
        ),
      ];
    }

    return [];
  }
}
