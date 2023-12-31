import 'dart:math';

import 'package:flutter/material.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/chart_utils.dart';
import 'package:beering/views/base/base_pageview.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../views/dialog_widgets/views/dialog_defaultpicker.dart';
import '../controllers/report_info_femmalehealth_controller.dart';

class ReportInfoFemmalehealthView
    extends GetView<ReportInfoFemmalehealthController> {
  const ReportInfoFemmalehealthView({Key? key}) : super(key: key);

  Widget _getDisplayOne() {
    return Container(
      margin: EdgeInsets.only(top: 30.w, left: 12.w, right: 12.w, bottom: 30.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 300.w,
      child: SfDateRangePicker(
        controller: controller.rangePickerController,
        headerStyle: DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: Get.textTheme.labelLarge,
        ),
        headerHeight: 36.w,
        showNavigationArrow: true,
        showTodayButton: false,
        initialSelectedDate: DateTime.now(),
        cellBuilder: (context, cellDetails) {
          bool isSaely = false;
          bool isHoliday = false;
          var textString = "";
          if (controller.rangePickerController.view ==
              DateRangePickerView.month) {
            textString = cellDetails.date.day.toString();
          } else if (controller.rangePickerController.view ==
              DateRangePickerView.year) {
            textString = cellDetails.date.month.toString();
          } else if (controller.rangePickerController.view ==
              DateRangePickerView.decade) {
            textString = cellDetails.date.year.toString();
          } else {
            final int yearValue = (cellDetails.date.year ~/ 10) * 10;
            textString =
                yearValue.toString() + ' - ' + (yearValue + 9).toString();
          }

          var state = KFemmaleStatusType.values[Random.secure().nextInt(3)];

          return ChartUtils.getDateCellItem(
            text: textString,
            icon: state.image(),
            width: 30,
            height: 30,
            margin: EdgeInsets.only(bottom: 6),
          );
        },
        onCancel: () {},
        onSubmit: (Object? value) {},
        selectionColor: Colors.transparent,
        todayHighlightColor: Get.textTheme.labelMedium?.color,
        monthViewSettings: DateRangePickerMonthViewSettings(
          viewHeaderHeight: 20.w,
          viewHeaderStyle: DateRangePickerViewHeaderStyle(
            textStyle: Get.textTheme.labelMedium,
          ),
        ),
      ),
    );
  }

  Widget _getDisplayTwo() {
    List<String> datas = ListEx.generateArray<String>(3, 10, 1);

    return Container(
        margin:
            EdgeInsets.only(top: 30.w, left: 12.w, right: 12.w, bottom: 30.w),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(12),
        ),
        height: 300.w,
        child: KCupertinoPicker(
          backgroundColor: ColorUtils.fromHex("#FF232126"),
          itemExtent: 44.w,
          scrollController: FixedExtentScrollController(
            initialItem: 0,
          ),
          onSelectedItemChanged: (a) {},
          selectionOverlay: KCupertinoPickerDefaultOverlay(
            margin: EdgeInsets.only(left: 12.w, right: 12.w),
            borderRadius: BorderRadius.circular(12),
            color: ColorUtils.fromHex("#FF000000"),
            symbolText: Text(
              "Day",
              style: Get.textTheme.bodyLarge,
            ),
          ),
          children: datas
              .map((e) => Container(
                    alignment: Alignment.center,
                    child: Text(
                      e,
                      style: Get.textTheme.bodyLarge,
                    ),
                  ))
              .toList(),
        ));
  }

  Widget getDisplayNotAuth() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            20.columnWidget,
            LoadAssetsImage(
              "icons/female",
              width: 215,
              height: 178,
            ),
            Container(
              margin: EdgeInsets.only(top: 23.w),
              child: Text(
                "last_period_start".tr,
                style: Get.textTheme.labelLarge?.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),
            PageView(
              children: [
                _getDisplayOne(),
                _getDisplayTwo(),
                _getDisplayTwo(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getDisplayAuth() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      hiddenAppBar: true,
      safeAreaTop: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: KHealthDataType.FEMALE_HEALTH.getReportGradient(),
        ),
        child: Column(
          children: [
            getAppBar(
                KHealthDataType.FEMALE_HEALTH.getDisplayName(isReport: true)),

            Obx(() => controller.femmalState.value == true
                ? getDisplayAuth()
                : getDisplayNotAuth()),

            // NextButton(
            //   onPressed: () {},
            //   title: "next_steps".tr,
            //   margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 20.w),
            //   textStyle: Get.textTheme.displayLarge,
            //   height: 44.w,
            //   gradient: LinearGradient(colors: [
            //     ColorUtils.fromHex("#FF0E9FF5"),
            //     ColorUtils.fromHex("#FF02FFE2"),
            //   ]),
            //   borderRadius: 22,
            // ),
          ],
        ),
      ),
    );
  }
}
