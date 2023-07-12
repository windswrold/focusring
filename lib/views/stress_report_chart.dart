import 'dart:math';

import 'package:focusring/utils/custom_segment_render.dart';
import 'package:focusring/views/heartrate_report_chart.dart';
import 'package:focusring/views/report_footer.dart';
import 'package:focusring/views/today_overview.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../public.dart';
import 'charts/home_card/model/home_card_x.dart';

class StressReportChart extends StatelessWidget {
  const StressReportChart({Key? key, required this.pageType}) : super(key: key);

  final int pageType;

  Widget _buildHeader() {
    return Container(
      height: 270.w,
      margin: EdgeInsets.only(top: 20.w, left: 12.w, right: 12.w),
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
          ColumnSeries<HomeCardItemModel, String>(
            dataSource: List.generate(
                30,
                (index) => HomeCardItemModel(
                    x: "15:$index", y: Random.secure().nextDouble() * 500)),
            isTrackVisible: false,
            borderRadius: BorderRadius.circular(3),
            xValueMapper: (HomeCardItemModel sales, _) => sales.x,
            yValueMapper: (HomeCardItemModel sales, _) => sales.y,
            pointColorMapper: (datum, index) => datum.color,
            dataLabelSettings: const DataLabelSettings(
              isVisible: false,
            ),
            onPointTap: (pointInteractionDetails) {
              vmPrint(pointInteractionDetails.seriesIndex);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMaxMin() {
    Widget _buildItem({
      required String title,
      required String value,
    }) {
      return Column(
        children: [
          Text(
            value,
            style: Get.textTheme.headlineSmall,
          ),
          Text(title, style: Get.textTheme.bodyMedium),
        ],
      );
    }

    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildItem(title: "max_stress".tr, value: '111'),
          150.rowWidget,
          _buildItem(title: "min_stress".tr, value: "222"),
        ],
      ),
    );
  }

  Widget _getFooter() {
    Widget _buildItem({
      required KStressStatus status,
      required double value,
    }) {
      return Container(
        margin: EdgeInsets.only(top: 12.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status.getStatusDesc() + status.getStateCondition(status),
                  style: Get.textTheme.displayLarge,
                ),
                Text(
                  "$value",
                  style: Get.textTheme.displayLarge,
                ),
              ],
            ),
            12.columnWidget,
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.5,
                color: status.getStatusColor(),
                backgroundColor: ColorUtils.fromHex("#FF232126"),
                minHeight: 8,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Row(
            children: [
              LoadAssetsImage(
                "icons/status_card_icon_stress",
                width: 30,
                height: 30,
              ),
              8.rowWidget,
              Text(
                "stress_percent".tr,
                style: Get.textTheme.displayLarge,
              ),
            ],
          ),
          _buildItem(status: KStressStatus.normal, value: 10),
          _buildItem(status: KStressStatus.mild, value: 10),
          _buildItem(status: KStressStatus.moderate, value: 10),
          _buildItem(status: KStressStatus.severe, value: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMaxMin(),
        _buildHeader(),
        _getFooter(),
        NextButton(
          onPressed: () {},
          title: "strat_test".tr,
          margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 20.w),
          textStyle: Get.textTheme.displayLarge,
          height: 44.w,
          gradient: LinearGradient(colors: [
            ColorUtils.fromHex("#FF0E9FF5"),
            ColorUtils.fromHex("#FF02FFE2"),
          ]),
          borderRadius: 22,
        ),
      ],
    );
  }
}
