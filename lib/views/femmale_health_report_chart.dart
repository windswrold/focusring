import '../public.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FemmaleHealthReportChart extends StatelessWidget {
  const FemmaleHealthReportChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 64.w),
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
          SfDateRangePicker(
            // extendableRangeSelectionDirection: selectionDirection,
            // enablePastDates: enablePastDates,
            // minDate: minDate,
            // maxDate: maxDate,
            // enableMultiView: enableMultiView,
            // allowViewNavigation: enableViewNavigation,
            // showActionButtons: showActionButtons,
            // selectionMode: mode,
            // controller: controller,
            // showTodayButton: showTodayButton,
            // headerStyle: DateRangePickerHeaderStyle(
            //     textAlign: enableMultiView ? TextAlign.center : TextAlign.left),
            onCancel: () {
             
            },
            onSubmit: (Object? value) {
             
            },
            monthViewSettings: DateRangePickerMonthViewSettings(),
          ),
        ],
      ),
    );
  }
}
