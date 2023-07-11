import 'package:syncfusion_flutter_charts/charts.dart';

import '../public.dart';
import 'charts/home_card/model/home_card_x.dart';

class HeartrateReportSubviewChart extends StatelessWidget {
  const HeartrateReportSubviewChart({Key? key, required this.pageType})
      : super(key: key);

  final int pageType;

  Widget _getTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
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
      ),
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
      // padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Container(
            height: 170.w,
            width: 170.w,
            margin: EdgeInsets.only(top: 33.w),
            child: SfCircularChart(
              series: [
                DoughnutSeries<HomeCardItemModel, String>(
                  radius: '100%',
                  selectionBehavior: SelectionBehavior(enable: false),
                  dataSource: <HomeCardItemModel>[
                    HomeCardItemModel(
                      x: 'Chlorine',
                      y: 55,
                    ),
                    HomeCardItemModel(
                      x: 'Sodium',
                      y: 31,
                    ),
                    HomeCardItemModel(x: 'Magnesium', y: 7.7),
                    HomeCardItemModel(
                      x: 'Sulfur',
                      y: 3.7,
                    ),
                    HomeCardItemModel(
                      x: 'Calcium',
                      y: 1.2,
                    ),
                    HomeCardItemModel(
                      x: 'Others',
                      y: 1.4,
                    ),
                  ],
                  xValueMapper: (HomeCardItemModel data, _) => data.x as String,
                  yValueMapper: (HomeCardItemModel data, _) => data.y,
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30.w, left: 12.w, right: 12.w),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.w),
      // padding: EdgeInsets.only(top: 16.w, bottom: 12.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _getTitle(),
          pageType == 0 ? _getDay() : _getWeek(),
        ],
      ),
    );
  }
}
