import 'dart:math';

import 'package:focusring/theme/theme.dart';
import 'package:focusring/views/report_footer.dart';
import 'package:focusring/views/target_completion_rate.dart';

import '../public.dart';

class SleepTimeSubviewChart extends StatelessWidget {
  const SleepTimeSubviewChart({Key? key, required this.pageType})
      : super(key: key);

  final KReportType pageType;

  Widget _getTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          LoadAssetsImage(
            "icons/status_card_icon_sleep",
            width: 35,
            height: 35,
          ),
          8.rowWidget,
          Text(
            "sleep_subtype".tr,
            style: Get.textTheme.displayLarge,
          ),
        ],
      ),
    );
  }

  Widget _getDay() {
    Widget _buildSleepItem(
        {required double width, required KSleepStatus status}) {
      return Container(
        width: width,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: status == KSleepStatus.awake
                    ? status.getStatusColor()
                    : Colors.transparent,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: status == KSleepStatus.awake
                          ? Colors.red
                          : Colors.transparent,
                    ),
                    left: BorderSide(
                      color: status == KSleepStatus.lightSleep
                          ? Colors.red
                          : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     LoadAssetsImage(
            //       "icons/sleep_line_ltow",
            //       width: 2,
            //       height: 28,
            //     ),
            //     LoadAssetsImage(
            //       "icons/sleep_line_wtol",
            //       width: 2,
            //       height: 28,
            //     ),
            //   ],
            // ),
            //   ),
            // ),
            Expanded(
              child: Container(
                color: status == KSleepStatus.lightSleep
                    ? status.getStatusColor()
                    : Colors.transparent,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: status == KSleepStatus.lightSleep
                          ? Colors.red
                          : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: status == KSleepStatus.deepSleep
                    ? status.getStatusColor()
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildSleepTime(
        {required KSleepStatus status, required String result}) {
      return Container(
        margin: EdgeInsets.only(top: 12.w),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: status.getStatusColor(),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            10.rowWidget,
            Text(
              status.getStatusDesc(),
              style: Get.textTheme.displayLarge,
            ),
            Expanded(
              child: Text(
                result,
                style: Get.textTheme.displayLarge,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Column(
        children: [
          Container(
            height: 28.w * 5,
            child: ListView.builder(
              itemCount: 30,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _buildSleepItem(
                  width: Random.secure().nextInt(30).toDouble(),
                  status: KSleepStatus.values[Random.secure().nextInt(3)],
                );
              },
            ),
          ),
          Container(
            height: 1,
            margin: EdgeInsets.only(top: 2, bottom: 9.w),
            color: ColorUtils.fromHex("#FF2C2F2F"),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "data",
                  style: Get.textTheme.displaySmall
                      ?.copyWith(fontFamily: fontFamilyRoboto),
                ),
                Text(
                  "data",
                  style: Get.textTheme.displaySmall
                      ?.copyWith(fontFamily: fontFamilyRoboto),
                ),
              ],
            ),
          ),
          _buildSleepTime(status: KSleepStatus.deepSleep, result: "result"),
          _buildSleepTime(status: KSleepStatus.lightSleep, result: "result"),
          _buildSleepTime(status: KSleepStatus.awake, result: "result"),
        ],
      ),
    );
  }

  Widget _getWeek() {
    Widget _buildSleepTime({required String title, required String result}) {
      return Container(
        margin: EdgeInsets.only(top: 12.w),
        child: Row(
          children: [
            Text(
              title,
              style: Get.textTheme.displayLarge,
            ),
            Expanded(
              child: Text(
                result,
                style: Get.textTheme.displayLarge,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Column(
        children: [
          _buildSleepTime(title: "average_sleeptime".tr, result: "result"),
          _buildSleepTime(title: "average_deepsleeptime".tr, result: "result"),
          _buildSleepTime(title: "average_lighrsleeptime".tr, result: "result"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TargetCompletionRate(
          pageType: pageType,
          type: KHealthDataType.SLEEP,
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
          padding: EdgeInsets.only(top: 16.w, bottom: 12.w),
          decoration: BoxDecoration(
            color: ColorUtils.fromHex("#FF000000"),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _getTitle(),
              pageType == KReportType.day ? _getDay() : _getWeek(),
            ],
          ),
        ),
        const ReportFooter(
          type: KHealthDataType.SLEEP,
        ),
      ],
    );
  }
}
