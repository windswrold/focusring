import 'package:syncfusion_flutter_charts/charts.dart';

import '../public.dart';
import '../views/charts/home_card/model/home_card_x.dart';

class ChartUtils {
  static getDateCellItem({
    required String text,
    required String icon,
    double? width,
    double? height,
    double bottom = 0,
  }) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(bottom: bottom),
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

  static List<ChartSeries> getHomeItemServices(
      {required KHealthDataType type, required List<KChartCellData> datas}) {
    if (type == KHealthDataType.STEPS ||
        type == KHealthDataType.LiCheng ||
        type == KHealthDataType.CALORIES_BURNED ||
        type == KHealthDataType.STRESS) {
      return [
        ColumnSeries<KChartCellData, String>(
          dataSource: datas,
          isTrackVisible: true,
          trackColor: ColorUtils.fromHex("#FF212526"),
          trackBorderWidth: 0,
          borderRadius: BorderRadius.circular(3),
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.y,
          pointColorMapper: (datum, index) => datum.color,
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
        ),
      ];
    } else if (type == KHealthDataType.HEART_RATE) {
      return [
        SplineAreaSeries<KChartCellData, String>(
          dataSource: datas,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.transparent],
          ),
          borderWidth: 2,
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.y,
        ),
      ];
    } else if (type == KHealthDataType.BLOOD_OXYGEN ||
        type == KHealthDataType.BODY_TEMPERATURE) {
      return [
        ColumnSeries<KChartCellData, String>(
          dataSource: List.generate(30,
              (index) => KChartCellData(x: index.toString(), y: 0.toDouble())),
          isTrackVisible: true,
          trackColor: ColorUtils.fromHex("#212621"),
          borderRadius: BorderRadius.circular(3),
          trackBorderWidth: 0,
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
        ),
        ScatterSeries<KChartCellData, String>(
          dataSource: datas,
          xValueMapper: (KChartCellData sales, _) => sales.x,
          yValueMapper: (KChartCellData sales, _) => sales.y,
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
          dataSource: datas,
          isTrackVisible: false,
          spacing: 0,
          borderRadius:const BorderRadius.only(
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
          dataSource: datas,
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
          dataSource: datas,
          isTrackVisible: false,
          spacing: 0,
          borderRadius: const BorderRadius.only(
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
      ];
    }

    return [];
  }
}
