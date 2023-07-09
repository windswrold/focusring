import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../public.dart';

class StepsLiChengChart extends StatelessWidget {
  const StepsLiChengChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 278.w,
        padding: EdgeInsets.only(top: 40.w, bottom: 10.w),
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
            tooltipSettings: InteractiveTooltip(
                // borderColor: Colors.blue, // 设置浮动球的边框颜色
                // color: Colors.blue, // 设置浮动球的填充颜色
                // borderRadius: BorderRadius.circular(8), // 设置浮动球的圆角半径
                // elevation: 2,
                ),
          ),
          series: <ColumnSeries<HomeCardItemModel, String>>[
            ColumnSeries<HomeCardItemModel, String>(
              dataSource: List.generate(
                  30,
                  (index) =>
                      HomeCardItemModel(x: "15:$index", y: index.toDouble())),
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
        ));
  }
}
