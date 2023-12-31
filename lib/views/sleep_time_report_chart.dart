import 'dart:math';

import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:beering/app/modules/report_info_steps/controllers/report_info_steps_controller.dart';
import 'package:beering/theme/theme.dart';
import 'package:beering/utils/chart_utils.dart';
import 'package:beering/utils/date_util.dart';
import 'package:beering/views/report_footer.dart';
import 'package:beering/views/target_completion_rate.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../app/data/user_info.dart';
import '../public.dart';
import 'charts/home_card/model/home_card_x.dart';

class SleepTimeReportChart extends StatelessWidget {
  const SleepTimeReportChart({Key? key, required this.pageType})
      : super(key: key);

  final KReportType pageType;

  Widget _getDayChart() {
    const thickness = 0.15;
    const maximum = 12.0;
    return Container(
      padding: EdgeInsets.only(top: 20.w, bottom: 16.w),
      height: 270.w,
      child: GetX<ReportInfoStepsController>(
        builder: (a) {
          return Column(
            children: [
              Expanded(
                  child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    axisLineStyle: const AxisLineStyle(
                      thickness: thickness + 0.05,
                      thicknessUnit: GaugeSizeUnit.factor,
                      color: Colors.transparent,
                    ),
                    minorTicksPerInterval: 15,
                    //间隔
                    majorTickStyle: MajorTickStyle(
                      color: ColorUtils.fromHex("#FF9EA3AE"),
                      length: 6,
                    ),
                    minorTickStyle: MinorTickStyle(
                      length: 2,
                      color: ColorUtils.fromHex("#FFE5E6EB"),
                    ),
                    maximum: maximum,
                    interval: 3,
                    startAngle: 270,
                    endAngle: 270,
                    radiusFactor: 1,
                    onLabelCreated: (AxisLabelCreatedArgs args) {
                      if (args.text == "0") {
                        args.text = "12";
                      }
                      args.labelStyle = GaugeTextStyle(
                        fontFamily: fontFamilyRoboto,
                        fontSize: 10.sp,
                        color: ColorUtils.fromHex("#FF9EA3AE"),
                        fontWeight: FontWeight.w400,
                      );
                    },
                    ranges: [
                      GaugeRange(
                        startValue: 0,
                        endValue: maximum,
                        sizeUnit: GaugeSizeUnit.factor,
                        color: ColorUtils.fromHex("#FF232126"),
                        startWidth: thickness,
                        endWidth: thickness,
                      ),
                      GaugeRange(
                        startValue: a.sleep_start.value?.getNumsMin() ?? 0,
                        endValue: a.sleep_end.value?.getNumsMin() ?? 0,
                        sizeUnit: GaugeSizeUnit.factor,
                        color: ColorUtils.fromHex("#FF766AFF"),
                        startWidth: thickness,
                        endWidth: thickness,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      // 中间子
                      GaugeAnnotation(
                        axisValue: 0,
                        widget: Container(
                          child: a.sleep_time.value == null
                              ? Container()
                              : RichText(
                                  text: TextSpan(
                                    text:
                                        a.sleep_time.value?.inHours.toString(),
                                    style: Get.textTheme.titleLarge,
                                    children: [
                                      TextSpan(
                                          text: "h",
                                          style: Get.textTheme.bodyMedium
                                              ?.copyWith(fontSize: 16.sp)),
                                      TextSpan(
                                        text: a.sleep_time.value?.inMinutes
                                            .remainder(60)
                                            .toString(),
                                        style: Get.textTheme.titleLarge,
                                      ),
                                      TextSpan(
                                        text: "min",
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(fontSize: 16.sp),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
              Container(
                padding: EdgeInsets.only(top: 25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "sleep_time".tr,
                          style: Get.textTheme.bodyMedium,
                        ),
                        11.columnWidget,
                        Row(
                          children: [
                            LoadAssetsImage(
                              "icons/sleep_icon_bedtime",
                              width: 13,
                              height: 13,
                            ),
                            5.rowWidget,
                            Text(
                              DateUtil.formatDate(a.sleep_start.value,
                                  format: DateFormats.h_m),
                              style: Get.textTheme.displayLarge,
                            ),
                          ],
                        )
                      ],
                    ),
                    115.rowWidget,
                    Column(
                      children: [
                        Text(
                          "wakeup_time".tr,
                          style: Get.textTheme.bodyMedium,
                        ),
                        11.columnWidget,
                        Row(
                          children: [
                            LoadAssetsImage(
                              "icons/sleep_icon_wakeup",
                              width: 13,
                              height: 13,
                            ),
                            5.rowWidget,
                            Text(
                              DateUtil.formatDate(a.sleep_end.value,
                                  format: DateFormats.h_m),
                              style: Get.textTheme.displayLarge,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _getWeekChart() {
    return Container(
      padding: EdgeInsets.only(top: 30.w, bottom: 10.w),
      height: 308.w,
      child: Column(
        children: [
          GetX<ReportInfoStepsController>(builder: (a) {
            return AnimatedOpacity(
              opacity: a.chartTipValue.value.isEmpty ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding:
                    EdgeInsets.only(left: 21.w, right: 21.w, top: 4, bottom: 4),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: KHealthDataType.SLEEP.getTypeMainColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  a.chartTipValue.value,
                  style: Get.textTheme.labelSmall,
                ),
              ),
            );
          }),
          GetBuilder<ReportInfoStepsController>(
              id: ReportInfoStepsController.id_data_souce_update,
              builder: (a) {
                return Expanded(
                    child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  margin: const EdgeInsets.only(left: 5, right: 10),
                  primaryXAxis: ChartUtils.getCategoryAxis(),
                  primaryYAxis: ChartUtils.getNumericAxis(),
                  trackballBehavior: ChartUtils.getTrackballBehavior(
                    color: KHealthDataType.SLEEP.getTypeMainColor()!,
                  ),
                  onTrackballPositionChanging: (trackballArgs) {
                    vmPrint("onTrackballPositionChanging" +
                        trackballArgs.chartPointInfo.dataPointIndex.toString());

                    final index = trackballArgs.chartPointInfo.dataPointIndex;
                    a.onTrackballPositionChanging(index);
                  },
                  series: ChartUtils.getChartReportServices(
                      type: KHealthDataType.SLEEP, datas: a.chartLists),
                ));
              })
        ],
      ),
    );
  }

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

  Widget _buildSleepItem(
      {required double width, required KSleepStatusType status}) {
    return Container(
      width: width,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: status == KSleepStatusType.awake
                  ? status.getStatusColor()
                  : Colors.transparent,
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
              color: status == KSleepStatusType.lightSleep
                  ? status.getStatusColor()
                  : Colors.transparent,
            ),
          ),

          Expanded(
            child: Container(
              color: status == KSleepStatusType.deepSleep
                  ? status.getStatusColor()
                  : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTime(
      {required String title, required String result, Color? color}) {
    return Container(
      margin: EdgeInsets.only(top: 12.w),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          10.rowWidget,
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

  Widget _getDay() {
    return Container(
        margin: EdgeInsets.only(top: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: GetX<ReportInfoStepsController>(builder: (a) {
          return Column(
            children: [
              Container(
                height: 28.w * 5,
                width: 320.w,
                // color: Colors.red,
                child: ListView.builder(
                  itemCount: a.chartLists.tryFirst?.length ?? 0,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    KChartCellData? item = a.chartLists.tryFirst?[index];
                    return item == null
                        ? Container()
                        : _buildSleepItem(
                            width: item.yor_low * 320.w,
                            status: item.state ?? KSleepStatusType.awake,
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
                      DateUtil.formatDate(a.sleep_start.value,
                          format: DateFormats.h_m),
                      style: Get.textTheme.displaySmall
                          ?.copyWith(fontFamily: fontFamilyRoboto),
                    ),
                    Text(
                      DateUtil.formatDate(a.sleep_end.value,
                          format: DateFormats.h_m),
                      style: Get.textTheme.displaySmall
                          ?.copyWith(fontFamily: fontFamilyRoboto),
                    ),
                  ],
                ),
              ),
              Column(
                children: a.todaysModel.value
                    .map(
                      (data) => _buildDayTime(
                          title: data.title,
                          result: data.content,
                          color: data.color),
                    )
                    .toList(),
              )
            ],
          );
        }));
  }

  Widget _buildWeekTime({required String title, required String result}) {
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

  Widget _getWeek() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: GetX<ReportInfoStepsController>(builder: (a) {
          return Column(
              children: a.todaysModel.value
                  .map((e) => _buildWeekTime(title: e.title, result: e.content))
                  .toList());
        }));
  }

  @override
  Widget build(BuildContext context) {
    UserInfoModel? user = SPManager.getGlobalUser();
    final value = user?.getPlanNum(KHealthDataType.SLEEP);
    return Column(
      children: [
        pageType == KReportType.day ? _getDayChart() : _getWeekChart(),
        GetX<ReportInfoStepsController>(builder: (a) {
          return TargetCompletionRateView(
            pageType: pageType,
            type: KHealthDataType.SLEEP,
            targetNum: (value ?? 0).toString(),
            complationNum: a.complationData.value,
            datas: a.targetWeekData.value,
          );
        }),
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
        const ReportFooterView(
          type: KHealthDataType.SLEEP,
        ),
      ],
    );
  }
}
