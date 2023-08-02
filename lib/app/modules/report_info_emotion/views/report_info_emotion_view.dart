import 'package:flutter/material.dart';
import 'package:focusring/public.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/tra_led_button.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/report_info_emotion_controller.dart';

class ReportInfoEmotionView extends GetView<ReportInfoEmotionController> {
  const ReportInfoEmotionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      hiddenAppBar: true,
      safeAreaTop: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: KHealthDataType.EMOTION.getReportGradient(),
        ),
        child: Column(
          children: [
            getAppBar(
              KHealthDataType.EMOTION.getDisplayName(isReport: true),
            ),
            TraLedButton(),
            Container(
              margin: EdgeInsets.only(top: 10.w),
              child: Column(
                children: [
                  Text(
                    "89000",
                    style: Get.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    KHealthDataType.EMOTION
                        .getDisplayName(isReportSmallTotal: true),
                    style: Get.textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            _getChart(),
            _getOtherView(),
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
            )
          ],
        ),
      ),
    );
  }

  Widget _getArrowTitle() {
    return Container(
      margin: EdgeInsets.only(left: 61.w, right: 61.w, top: 12.w),
      child: Row(
        children: [
          NextButton(
            onPressed: () {},
            width: 29,
            height: 29,
            bgImg: assetsImages + "icons/report_arrow_left@3x.png",
            title: "",
          ),
          Expanded(
            child: Text(
              "data",
              textAlign: TextAlign.center,
            ),
          ),
          NextButton(
            onPressed: () {},
            width: 29,
            height: 29,
            bgImg: assetsImages + "icons/report_arrow_right@3x.png",
            title: "",
          ),
        ],
      ),
    );
  }

  Widget _getChart() {
    return Container(
      height: 265.w,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      alignment: Alignment.center,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: EdgeInsets.zero,
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
          isVisible: false,
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
                      y: 40,
                    )),
            isTrackVisible: false,
            spacing: 0,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(3),
              bottomLeft: Radius.circular(3),
            ),
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
                      y: 15,
                    )),
            isTrackVisible: false,
            spacing: 0,
            borderRadius: BorderRadius.zero,
            xValueMapper: (KChartCellData sales, _) => sales.x,
            yValueMapper: (KChartCellData sales, _) => sales.y,
            pointColorMapper: (datum, index) => Colors.blue,
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
                      y: 100,
                    )),
            isTrackVisible: false,
            spacing: 0,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3),
              topRight: Radius.circular(3),
            ),
            xValueMapper: (KChartCellData sales, _) => sales.x,
            yValueMapper: (KChartCellData sales, _) => sales.y,
            pointColorMapper: (datum, index) => Colors.yellow,
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

  Widget _getOtherView() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                LoadAssetsImage(
                  "icons/report_icon_emotion",
                  width: 32,
                  height: 32,
                ),
                10.rowWidget,
                Text(
                  "eMOTION_status".tr,
                  style: Get.textTheme.displayLarge,
                ),
              ],
            ),
            _buildItem(),
            _buildItem(),
            _buildItem(),
          ],
        ));
  }

  Widget _buildItem() {
    return Container(
      margin: EdgeInsets.only(top: 12.w),
      child: Row(
        children: [
          Text(
            "data",
            style: Get.textTheme.displayLarge,
          ),
          10.rowWidget,
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.5,
                color: Colors.yellow,
                // valueColor: AlwaysStoppedAnimation(Colors.red),
                backgroundColor: ColorUtils.fromHex("#FF232126"),
                minHeight: 8,
              ),
            ),
          ),
          10.rowWidget,
          Text(
            "data",
            style: Get.textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}
