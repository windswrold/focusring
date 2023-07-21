import 'package:focusring/views/report_footer.dart';
import 'package:focusring/views/today_overview.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../public.dart';
import 'charts/home_card/model/home_card_x.dart';

class HeartrateReportSubviewChart extends StatelessWidget {
  const HeartrateReportSubviewChart({Key? key, required this.pageType})
      : super(key: key);

  final int pageType;

  Widget _getTitle() {
    return Row(
      children: [
        LoadAssetsImage(
          "icons/status_card_icon_hr",
          width: 35,
          height: 35,
        ),
        8.rowWidget,
        Text(
          "heartrate_subtype".tr,
          style: Get.textTheme.displayLarge,
        ),
      ],
    );
  }

  Widget _getDay() {
    Widget _builditem(KHeartRateStatus status, String value) {
      return Container(
        margin: EdgeInsets.only(bottom: 11.w),
        child: Row(
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: status.getStatusColor(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12.w),
              child: Text(
                status.getStatusDesc() + status.getStateCondition(status),
                style: Get.textTheme.displayLarge,
              ),
            ),
            Expanded(child: Container()),
            Container(
              child: Text(
                value,
                style: Get.textTheme.displayLarge,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.w),
      margin: EdgeInsets.only(top: 12.w, left: 12.w, right: 12.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _getTitle(),
          Container(
            height: 170.w,
            width: 170.w,
            child: SfCircularChart(
              series: [
                DoughnutSeries<KChartCellData, String>(
                  radius: '100%',
                  selectionBehavior: SelectionBehavior(enable: false),
                  dataSource: <KChartCellData>[
                    KChartCellData(
                      x: 'Chlorine',
                      y: 55,
                    ),
                    KChartCellData(
                      x: 'Sodium',
                      y: 31,
                    ),
                    KChartCellData(x: 'Magnesium', y: 7.7),
                    KChartCellData(
                      x: 'Sulfur',
                      y: 3.7,
                    ),
                    KChartCellData(
                      x: 'Calcium',
                      y: 1.2,
                    ),
                    KChartCellData(
                      x: 'Others',
                      y: 1.4,
                    ),
                  ],
                  xValueMapper: (KChartCellData data, _) => data.x as String,
                  yValueMapper: (KChartCellData data, _) => data.y,
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25.w, left: 12.w, right: 12.w),
            child: Column(
              children: KHeartRateStatus.values
                  .map((e) => _builditem(e, "value"))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getWeek() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 12.w, right: 12.w),
          child: TodayOverView(datas: [
            TodayOverViewModel(title: "resting_heartrate".tr, content: "1"),
            TodayOverViewModel(title: "max_heartrate".tr, content: "2"),
            TodayOverViewModel(title: "min_heartrate".tr, content: "3"),
          ]),
        ),
        pageType == 0 ? _getDay() : _getWeek(),
        // _getFooter(),
        const ReportFooter(
          type: KHealthDataType.HEART_RATE,
        ),
      ],
    );
  }

  Widget _getFooter() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
        margin: EdgeInsets.only(top: 12.w),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "manual_record".tr,
              style: Get.textTheme.displayLarge,
            ),
            LoadAssetsImage(
              "icons/arrow_right_small",
              width: 7,
              height: 12,
            ),
          ],
        ));
  }
}
