import 'dart:math';

import 'package:flutter/material.dart';
import 'package:focusring/public.dart';
import 'package:focusring/utils/chart_utils.dart';
import 'package:focusring/views/charts/home_card/model/home_card_type.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomeCardView extends StatelessWidget {
  const HomeCardView({Key? key, required this.model}) : super(key: key);

  final KHomeCardModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 351.w,
      height: model.datas.isEmpty ? 72.w : 200.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "$assetsImages${model.type!.getIcon(isBgIcon: true, isEmptyIcon: model.datas.isEmpty)}@3x.png",
          ),
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        children: [
          _buildTitle(),
          _buildChart(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(left: 14.w, top: 15.w, right: 14.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              LoadAssetsImage(
                model.type!.getIcon(isCardIcon: true),
                width: 35,
                height: 35,
              ),
              11.rowWidget,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.type!.getDisplayName(),
                    style: Get.textTheme.bodySmall,
                  ),
                  2.columnWidget,
                  Text(
                    model.date ?? "",
                    style: Get.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: (model.datas.isNotEmpty),
                child: RichText(
                  text: TextSpan(
                    text: (model.result ?? ""),
                    style: Get.textTheme.bodyLarge,
                    children: [
                      TextSpan(
                        text: model.type!.getSymbol(),
                        style: Get.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: model.resultDesc != null,
                child: Text(
                  model.resultDesc ?? "",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Visibility(
      visible: model.datas.isNotEmpty,
      child: Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 22.w, left: 10.w, right: 10.w),
          child: _buildChartItem(),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      height: 36.w,
      child: Visibility(
        visible: model.type != KHealthDataType.FEMALE_HEALTH,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              model.startDesc ?? "",
              style: Get.textTheme.labelLarge,
            ),
            Text(
              model.endDesc ?? "",
              style: Get.textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartItem() {
    if (model.type == KHealthDataType.SLEEP) {
      return _buildSleep();
    } else if (model.type == KHealthDataType.FEMALE_HEALTH) {
      return SfDateRangePicker(
        headerHeight: 0,
        showNavigationArrow: false,
        // showTodayButton: false,
        initialDisplayDate: DateTime.now(),
        initialSelectedDate: DateTime.now(),
        selectionMode: DateRangePickerSelectionMode.single,
        selectionColor: Colors.transparent,
        todayHighlightColor: Get.textTheme.labelMedium?.color,
        enablePastDates: false,
        monthViewSettings: const DateRangePickerMonthViewSettings(
          viewHeaderHeight: 0,
          numberOfWeeksInView: 2,
        ),
        selectionRadius: 0,
        monthCellStyle: DateRangePickerMonthCellStyle(
          todayCellDecoration: null,
          cellDecoration: null,
          todayTextStyle: Get.textTheme.displayMedium,
        ),
        cellBuilder: (context, cellDetails) {
          var textString = cellDetails.date.day.toString();
          var anquanqi = KFemmaleStatus.normal.image();
          return ChartUtils.getDateCellItem(
            text: textString,
            icon: anquanqi,
            width: 30,
            height: 30,
            margin: EdgeInsets.only(left: 10.w, right: 10.w),
          );
        },
      );
    } else {
      return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          isVisible: false,
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
          maximum: model.maximum,
        ),
        margin: EdgeInsets.zero,
        series: ChartUtils.getHomeItemServices(
            type: model.type!, datas: model.datas),
      );
    }
  }

  Widget _buildSleep() {
    return Container(
      height: 85.w,
      child: ListView.builder(
        itemCount: model.datas.first.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final item = model.datas.first[index];
          return _buildSleepItem(item: item);
        },
      ),
    );
  }

  Widget _buildSleepItem({required KChartCellData item}) {
    return Container(
      height: 85.w,
      width: item.y.toDouble(),
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: item.state == KSleepStatus.awake
                  ? KSleepStatus.awake.getStatusColor()
                  : Colors.transparent,
            ),
          ),
          Expanded(
            child: Container(
              color: item.state == KSleepStatus.lightSleep
                  ? KSleepStatus.lightSleep.getStatusColor()
                  : Colors.transparent,
            ),
          ),
          Expanded(
            child: Container(
              color: item.state == KSleepStatus.deepSleep
                  ? KSleepStatus.deepSleep.getStatusColor()
                  : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
