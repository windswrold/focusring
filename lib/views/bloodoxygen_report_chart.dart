
import 'package:focusring/app/modules/report_info_steps/controllers/report_info_steps_controller.dart';
import 'package:focusring/utils/chart_utils.dart';

import 'package:focusring/views/report_footer.dart';
import 'package:focusring/views/today_overview.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../public.dart';

class BloodOxygenReportChart extends StatelessWidget {
  const BloodOxygenReportChart({Key? key, required this.pageType})
      : super(key: key);

  final KReportType pageType;

  Widget _buildChart() {
    return Container(
      height: 280.w,
      padding: EdgeInsets.only(top: 40.w, bottom: 10.w),
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
                  color: KHealthDataType.BLOOD_OXYGEN.getTypeMainColor(),
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
                    color: KHealthDataType.BLOOD_OXYGEN.getTypeMainColor()!,
                  ),
                  onTrackballPositionChanging: (trackballArgs) {
                    vmPrint("onTrackballPositionChanging" +
                        trackballArgs.chartPointInfo.dataPointIndex.toString());
                    a.onTrackballPositionChanging(
                        trackballArgs.chartPointInfo.dataPointIndex);
                  },
                  series: ChartUtils.getChartReportServices(
                      datas: a.dataSource,
                      type: KHealthDataType.BLOOD_OXYGEN,
                      reportType: pageType),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildChart(),
        Container(
          margin: EdgeInsets.only(left: 12.w, right: 12.w),
          child: TodayOverView(
            datas: [
              TodayOverViewModel(title: "max_bloodoxygen".tr, content: "1"),
              TodayOverViewModel(title: "mininum_bloodoxygen".tr, content: "2"),
              TodayOverViewModel(title: "exception_number".tr, content: "3"),
            ],
            type: pageType,
          ),
        ),
        const ReportFooter(
          type: KHealthDataType.BLOOD_OXYGEN,
        ),
      ],
    );
  }
}
