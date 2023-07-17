import '../public.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FemmaleHealthReportChart extends StatelessWidget {
  const FemmaleHealthReportChart({Key? key}) : super(key: key);

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
              headerStyle: DateRangePickerHeaderStyle(
                textAlign: TextAlign.center,
                textStyle: Get.textTheme.labelLarge,
              ),
              headerHeight: 36.w,
              showNavigationArrow: true,
              selectableDayPredicate: (DateTime dateTime) {
                if (dateTime != DateTime(2022)) {
                  return false;
                }
                return true;
              },
              monthCellStyle: DateRangePickerMonthCellStyle(
                cellDecoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              // cellBuilder: (context, cellDetails) {
              //   vmPrint(cellDetails.date);

              //   // return null;
              //   // var safelyDays = [
              //   //   DateUtil.getNowDateStr(),
              //   //   DateUtil.getNowDateStr(),
              //   // ];
              //   // var legalHoliday = [
              //   //   DateUtil.getNowDateStr(),
              //   //   DateUtil.getNowDateStr(),
              //   //   DateUtil.getNowDateStr(),
              //   //   DateUtil.getNowDateStr(),
              //   // ];
              //   // if (safelyDays.contains(cellDetails.date)) {
              //   //   return Text("data222");
              //   // }
              //   return Container(
              //     width: cellDetails.bounds.width,
              //     height: cellDetails.bounds.height,
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(),
              //     child: Text(
              //       cellDetails.date.day.toString(),
              //       style: Get.textTheme.labelLarge,
              //     ),
              //   );
              // },
              onCancel: () {},
              onSubmit: (Object? value) {},
              selectionColor: ColorUtils.fromHex("#FF06E0E8"),
              selectionRadius: 18,
              monthViewSettings: DateRangePickerMonthViewSettings(),
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
