import 'dart:math';

import 'package:focusring/theme/theme.dart';
import 'package:focusring/utils/chart_utils.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/report_footer.dart';
import 'package:focusring/views/target_completion_rate.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../public.dart';

class StepsLiChengReportChart extends StatelessWidget {
  const StepsLiChengReportChart(
      {Key? key, required this.pageType, required this.type})
      : super(key: key);

  final KReportType pageType;

  final KHealthDataType type;

  @override
  Widget build(BuildContext context) {
    List<Widget> datas = [];
    if (pageType == KReportType.day) {
      if (type == KHealthDataType.STEPS) {
        datas.add(
          _getCardItem(
              bgIcon: "bg/dayreport_bg_carolies",
              cardIcon: "icons/mine_icon_calories",
              type: "all_xiaohao".tr,
              pageType: pageType,
              value: "123 kcal"),
        );
        datas.add(
          _getCardItem(
              bgIcon: "bg/dayreport_bg_distance",
              cardIcon: "icons/mine_icon_distance",
              type: "all_lichen".tr,
              pageType: pageType,
              value: "123 kcal"),
        );
      } else if (type == KHealthDataType.CALORIES_BURNED) {
        datas.add(
          _getCardItem(
              bgIcon: "bg/dayreport_bg_steps",
              cardIcon: "icons/mine_icon_steps",
              type: "all_stepsnum".tr,
              pageType: pageType,
              value: "123 kcal"),
        );
        datas.add(
          _getCardItem(
              bgIcon: "bg/dayreport_bg_distance",
              cardIcon: "icons/mine_icon_distance",
              type: "all_lichen".tr,
              pageType: pageType,
              value: "123 kcal"),
        );
      } else if (type == KHealthDataType.LiCheng) {
        datas.add(
          _getCardItem(
              bgIcon: "bg/dayreport_bg_carolies",
              cardIcon: "icons/mine_icon_calories",
              type: "all_stepsnum".tr,
              pageType: pageType,
              value: "123 kcal"),
        );
        datas.add(
          _getCardItem(
              bgIcon: "bg/dayreport_bg_steps",
              cardIcon: "icons/mine_icon_steps",
              type: "all_stepsnum".tr,
              pageType: pageType,
              value: "123 kcal"),
        );
      }
    } else {
      datas.add(
        _getCardItem(
          bgIcon: "bg/weekreport_bg_steps",
          cardIcon: "icons/mine_icon_steps",
          type: "average_stepsnum".tr,
          value: "123 kcal",
          pageType: pageType,
        ),
      );
      datas.add(
        _getCardItem(
            bgIcon: "bg/weekreport_bg_carolies",
            cardIcon: "icons/mine_icon_calories",
            type: "all_xiaohao".tr,
            pageType: pageType,
            value: "123 kcal"),
      );
      datas.add(
        _getCardItem(
            bgIcon: "bg/weekreport_bg_distance",
            cardIcon: "icons/mine_icon_distance",
            type: "all_lichen".tr,
            pageType: pageType,
            value: "123 kcal"),
      );
    }

    return Column(
      children: [
        Container(
            height: 278.w,
            padding: EdgeInsets.only(top: 40.w, bottom: 10.w),
            child: Column(
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
                    margin: EdgeInsets.only(left: 5, right: 10),
                    primaryXAxis: ChartUtils.getCategoryAxis(),
                    primaryYAxis: ChartUtils.getNumericAxis(),
                    onSelectionChanged: (selectionArgs) {
                      vmPrint("onSelectionChanged" +
                          selectionArgs.seriesIndex.toString());
                    },
                    trackballBehavior: ChartUtils.getTrackballBehavior(
                      color: KHealthDataType.STEPS.getTypeMainColor()!,
                    ),
                    onTrackballPositionChanging: (trackballArgs) {
                      vmPrint("onTrackballPositionChanging" +
                          trackballArgs.chartPointInfo.dataPointIndex
                              .toString());
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
            )),
        TargetCompletionRate(
          pageType: pageType,
          type: type,
          targetNum: "8000",
          complationNum: 55,
          datas: KTheme.weekColors
              .map((e) => TargetWeekCompletionRateModel(
                  color: e,
                  dayNum: "1",
                  complationNum: Random.secure().nextInt(100).toDouble()))
              .toList(),
        ),
        Container(
          margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: datas,
          ),
        ),
        ReportFooter(
          type: type,
        ),
      ],
    );
  }

  Widget _getCardItem({
    required String bgIcon,
    required String cardIcon,
    required String type,
    required String value,
    required KReportType pageType,
  }) {
    if (pageType == KReportType.day) {
      return Container(
        width: 170.w,
        height: 70.w,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("$assetsImages$bgIcon@3x.png"),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LoadAssetsImage(
              cardIcon,
              width: 30,
              height: 30,
            ),
            11.rowWidget,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    type,
                    style: Get.textTheme.displayLarge,
                  ),
                  4.columnWidget,
                  Text(
                    value,
                    style: Get.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 110.w,
      height: 140.w,
      padding: EdgeInsets.only(top: 20.w, left: 2, right: 2),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("$assetsImages$bgIcon@3x.png"),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LoadAssetsImage(
            cardIcon,
            width: 26,
            height: 28,
          ),
          21.columnWidget,
          Text(
            type,
            style: Get.textTheme.displayLarge,
          ),
          4.columnWidget,
          Text(
            value,
            style: Get.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
