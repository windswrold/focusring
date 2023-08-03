import 'package:focusring/utils/chart_utils.dart';
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
