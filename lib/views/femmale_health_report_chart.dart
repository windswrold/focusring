import 'dart:math';

import '../public.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FemmaleHealthReportChart extends StatelessWidget {
  const FemmaleHealthReportChart({Key? key, required this.controller})
      : super(key: key);

  final DateRangePickerController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 60.w),
      child: Column(
        children: [
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
          Container(
            margin: EdgeInsets.only(top: 30.w, left: 12.w, right: 12.w),
            decoration: BoxDecoration(
              color: ColorUtils.fromHex("#FF000000"),
              borderRadius: BorderRadius.circular(12),
            ),
            height: 300.w,
            child: SfDateRangePicker(
              controller: controller,
              headerStyle: DateRangePickerHeaderStyle(
                textAlign: TextAlign.center,
                textStyle: Get.textTheme.labelLarge,
              ),
              headerHeight: 36.w,
              showNavigationArrow: true,
              showTodayButton: false,
              initialSelectedDate: DateTime.now(),
              cellBuilder: (context, cellDetails) {
                // vmPrint(cellDetails.date);

                bool isSaely = false;
                bool isHoliday = false;
                var textString = "";
                if (controller?.view == DateRangePickerView.month) {
                  textString = cellDetails.date.day.toString();
                } else if (controller?.view == DateRangePickerView.year) {
                  textString = cellDetails.date.month.toString();
                } else if (controller?.view == DateRangePickerView.decade) {
                  textString = cellDetails.date.year.toString();
                } else {
                  final int yearValue = (cellDetails.date.year ~/ 10) * 10;
                  textString =
                      yearValue.toString() + ' - ' + (yearValue + 9).toString();
                }

                var state = KFemmaleStatus.values[Random.secure().nextInt(3)];
              
                return Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(bottom: 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        state.image(),
                      ),
                    ),
                  ),
                  child: Text(
                    textString,
                    style: Get.textTheme.labelLarge,
                  ),
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
          ),
          NextButton(
            onPressed: () {},
            title: "next_steps".tr,
            margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 20.w),
            textStyle: Get.textTheme.displayLarge,
            height: 44.w,
            gradient: LinearGradient(colors: [
              ColorUtils.fromHex("#FF0E9FF5"),
              ColorUtils.fromHex("#FF02FFE2"),
            ]),
            borderRadius: 22,
          ),
        ],
      ),
    );
  }
}
