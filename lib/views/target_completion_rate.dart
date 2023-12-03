import 'package:beering/app/data/health_data_model.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/utils/date_util.dart';
import 'package:decimal/decimal.dart';

import '../app/data/user_info.dart';
import '../public.dart';
import '../theme/theme.dart';
import 'charts/progress_chart.dart';

class TargetWeekCompletionRateModel {
  final Color color;

  final String dayNum;

  double complationNum;

  TargetWeekCompletionRateModel(
      {required this.color, required this.dayNum, required this.complationNum});

  static List<TargetWeekCompletionRateModel> getWeekModel({
    required List<DateTime> weeksTimes,
    required List a,
    required KHealthDataType dataType,
    required Function(double) backData,
  }) {
    UserInfoModel? user = SPManager.getGlobalUser();
    int all = user?.getPlanNum(dataType) ?? 0;
    List<TargetWeekCompletionRateModel> models = [];
    double allPercent = 0; //总共一周下来完成的百分比 过滤没有值的
    double count = 0;
    try {
      for (int i = 0; i < weeksTimes.length; i++) {
        Color e = Colors.transparent;
        try {
          e = KTheme.weekColors[i];
        } catch (e) {}
        final d = weeksTimes[i];
        String time = DateUtil.formatDate(d, format: DateFormats.mo_d);
        TargetWeekCompletionRateModel model = TargetWeekCompletionRateModel(
            color: e, dayNum: time, complationNum: 0);

        for (int i = 0; i < a.length; i++) {
          final item = a[i];
          DateTime? createTime;

          String current = "";
          if (dataType == KHealthDataType.STEPS) {
            createTime = DateTime.parse((item as StepData).createTime ?? "");
            current = item.steps ?? "0";
          } else if (dataType == KHealthDataType.LiCheng) {
            createTime = DateTime.parse((item as StepData).createTime ?? "");
            current = item.distance ?? "0";
          } else if (dataType == KHealthDataType.CALORIES_BURNED) {
            createTime = DateTime.parse((item as StepData).createTime ?? "");
            current = item.calorie ?? "0";
          } else if (dataType == KHealthDataType.SLEEP) {
            createTime = DateTime.parse((item as SleepData).createTime ?? "");
            current = item.getSleepTime() ?? "0";
          }
          double percent = getPercent(
              current: Decimal.parse(current).toDouble(),
              all: Decimal.fromInt(all).toDouble());

          if (DateUtil.dayIsEqual(createTime ?? DateTime.now(), d)) {
            model.complationNum = percent;
            if (percent > 0) {
              count += 1;
              allPercent += percent;
            }
          }
        }
        models.add(model);
      }
    } catch (e) {
      vmPrint("getWeekModel $e", KBLEManager.logevel);
    }
    vmPrint("allPercent $allPercent,  count $count");
    backData(getPercent(current: allPercent, all: count));
    return models;
  }
}

class TargetCompletionRateView extends StatelessWidget {
  const TargetCompletionRateView(
      {Key? key,
      required this.pageType,
      required this.type,
      required this.targetNum,
      required this.complationNum,
      required this.datas})
      : super(key: key);

  final KReportType pageType;

  final KHealthDataType type;

  final String targetNum;
  final double complationNum;

  final List<TargetWeekCompletionRateModel> datas;

  Widget _getDayComplation() {
    var day =
        "${type.getDisplayName(isMubiao: true)}: $targetNum${type.getSymbol()}";
    Color? color = type.getTypeMainColor();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: Get.textTheme.displayLarge,
        ),
        Row(
          children: [
            ProgressChart(
              progressValue: complationNum,
              rangePointerColor: color,
              textColor: color,
            ),
            17.rowWidget,
            LoadAssetsImage(
              "icons/arrow_right_small",
              width: 7,
              height: 12,
            ),
          ],
        ),
      ],
    );
  }

  Widget _getWeekComplation() {
    var week = "average_completionrate".tr;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              week,
              style: Get.textTheme.displayLarge,
            ),
            Row(
              children: [
                Text(
                  "${(complationNum * 100).toStringAsFixed(2)}%",
                  style: Get.textTheme.displayLarge,
                ),
                17.rowWidget,
                LoadAssetsImage(
                  "icons/arrow_right_small",
                  width: 7,
                  height: 12,
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: datas
              .map((e) => _weeekItem(
                  progressValue: e.complationNum,
                  textColor: e.color,
                  dayNum: e.dayNum))
              .toList(),
        ),
      ],
    );
  }

  Widget _getMonethComplation() {
    var moneth = "average_completionrate".tr;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          moneth,
          style: Get.textTheme.displayLarge,
        ),
        Row(
          children: [
            Text(
              "${(complationNum * 100).toStringAsFixed(2)}%",
              style: Get.textTheme.displayLarge,
            ),
            17.rowWidget,
            LoadAssetsImage(
              "icons/arrow_right_small",
              width: 7,
              height: 12,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.w),
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      child: pageType == KReportType.day
          ? _getDayComplation()
          : pageType == KReportType.week
              ? _getWeekComplation()
              : _getMonethComplation(),
    );
  }

  Widget _weeekItem(
      {required double progressValue,
      required Color textColor,
      required String dayNum}) {
    return Container(
      padding: EdgeInsets.only(top: 10.w),
      child: Column(
        children: [
          ProgressChart(
              progressValue: progressValue,
              textColor: textColor,
              rangePointerColor: textColor),
          4.columnWidget,
          Text(
            dayNum,
            style: Get.textTheme.displaySmall,
          ),
        ],
      ),
    );
  }
}
