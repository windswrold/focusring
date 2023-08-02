import '../public.dart';
import 'charts/progress_chart.dart';

class TargetWeekCompletionRateModel {
  final Color color;

  final String dayNum;

  final double complationNum;

  TargetWeekCompletionRateModel(
      {required this.color, required this.dayNum, required this.complationNum});
}

class TargetCompletionRate extends StatelessWidget {
  const TargetCompletionRate(
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
                  "$complationNum%",
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
              "$complationNum%",
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
