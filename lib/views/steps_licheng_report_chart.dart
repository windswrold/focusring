import 'dart:math';

import 'package:focusring/app/data/steps_card_model.dart';
import 'package:focusring/app/modules/report_info_steps/controllers/report_info_steps_controller.dart';
import 'package:focusring/theme/theme.dart';
import 'package:focusring/utils/chart_utils.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/report_footer.dart';
import 'package:focusring/views/target_completion_rate.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../public.dart';

class StepsLiChengReportChart extends StatelessWidget {
  const StepsLiChengReportChart(
      {Key? key, required this.pageType, required this.type})
      : super(key: key);

  final KReportType pageType;

  final KHealthDataType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 280.w,
          padding: EdgeInsets.only(top: 40.w, bottom: 10.w),
          child: Column(
            children: [
              GetX<ReportInfoStepsController>(builder: (a) {
                return AnimatedOpacity(
                  opacity: a.chartTipValue.value.isEmpty ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 21.w, right: 21.w, top: 4, bottom: 4),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: type.getTypeMainColor(),
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
                        color: type.getTypeMainColor()!,
                      ),
                      onTrackballPositionChanging: (trackballArgs) {
                        vmPrint("onTrackballPositionChanging" +
                            trackballArgs.chartPointInfo.dataPointIndex
                                .toString());
                        a.onTrackballPositionChanging(
                            trackballArgs.chartPointInfo.dataPointIndex);
                      },
                      series: ChartUtils.getChartReportServices(
                        datas: a.dataSource,
                        type: type,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        TargetCompletionRate(
          pageType: pageType,
          type: type,
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
          child: GetX<ReportInfoStepsController>(builder: (a) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: a.stepsCards
                  .map((element) => _getCardItem(model: element))
                  .toList(),
            );
          }),
        ),
        ReportFooter(
          type: type,
        ),
      ],
    );
  }

  Widget _getCardItem({required StepsCardModel model}) {
    if (pageType == KReportType.day) {
      return Container(
        width: 170.w,
        height: 70.w,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("$assetsImages${model.bgIcon}@3x.png"),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LoadAssetsImage(
              model.cardIcon,
              width: 30,
              height: 30,
            ),
            11.rowWidget,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.type,
                    style: Get.textTheme.displayLarge,
                  ),
                  4.columnWidget,
                  Text(
                    model.value,
                    style: Get.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 110.w,
      height: 140.w,
      padding: EdgeInsets.only(top: 20.w, left: 2, right: 2),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("$assetsImages${model.bgIcon}@3x.png"),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LoadAssetsImage(
            model.cardIcon,
            width: 26,
            height: 28,
          ),
          21.columnWidget,
          Text(
            model.type,
            style: Get.textTheme.displayLarge,
          ),
          4.columnWidget,
          Text(
            model.value,
            style: Get.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
