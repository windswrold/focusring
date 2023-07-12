import 'dart:math';

import 'package:flutter/material.dart';
import 'package:focusring/app/modules/home_state/controllers/home_state_controller.dart';
import 'package:focusring/public.dart';
import 'package:focusring/views/charts/home_card/model/home_card_type.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/charts/radio_gauge_chart/model/radio_gauge_chart_model.dart';

import 'package:get/get.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class HomeCardItem extends StatelessWidget {
  const HomeCardItem({Key? key, required this.model}) : super(key: key);

  final KHealthDataClass model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 351.w,
      height: 200.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "$assetsImages${model.type!.getIcon(isBgIcon: true)}@3x.png",
          ),
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        children: [
          Container(
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
                          model.date ?? "bodyMedium",
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
                    RichText(
                      text: TextSpan(
                        text: (model.result ?? "result"),
                        style: Get.textTheme.bodyLarge,
                        children: [
                          TextSpan(
                            text: model.type!.getSymbol(),
                            style: Get.textTheme.labelSmall,
                          ),
                        ],
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
          ),
          Container(
            height: 85.w,
            margin: EdgeInsets.only(top: 18.w),
            child: _buildChartItem(),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Visibility(
      // visible: model.startDesc != null && model.endDesc != null,
      child: Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.startDesc ?? "startDesc",
                style: Get.textTheme.labelLarge,
              ),
              Text(
                model.endDesc ?? "endDesc",
                style: Get.textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartItem() {
    if (model.type == KHealthDataType.STEPS ||
        model.type == KHealthDataType.LiCheng ||
        model.type == KHealthDataType.CALORIES_BURNED ||
        model.type == KHealthDataType.STRESS) {
      return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          isVisible: false,
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
        ),
        series: _getSteps(),
      );
    } else if (model.type == KHealthDataType.SLEEP) {
      return _buildSleep();
    } else if (model.type == KHealthDataType.HEART_RATE) {
      return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          isVisible: false,
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
        ),
        series: _getHEARTRATE(),
      );
    } else if (model.type == KHealthDataType.BLOOD_OXYGEN ||
        model.type == KHealthDataType.BODY_TEMPERATURE) {
      return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          isVisible: false,
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
        ),
        series: _getBLOOD_OXYGEN(),
      );
    } else if (model.type == KHealthDataType.EMOTION) {
      return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          isVisible: false,
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
        ),
        series: _getEMOTION(),
      );
      return _buildEMOTION();
    } else if (model.type == KHealthDataType.FEMALE_HEALTH) {
      return Text("FEMALE_HEALTH");
    }

    return Container();
  }

  List<XyDataSeries<HomeCardItemModel, String>> _getBLOOD_OXYGEN() {
    return <XyDataSeries<HomeCardItemModel, String>>[
      ColumnSeries<HomeCardItemModel, String>(
        dataSource: List.generate(30,
            (index) => HomeCardItemModel(x: index.toString(), y: 0.toDouble())),
        isTrackVisible: true,
        trackColor: ColorUtils.fromHex("#212621"),
        borderRadius: BorderRadius.circular(3),
        trackBorderWidth: 0,
        xValueMapper: (HomeCardItemModel sales, _) => sales.x,
        yValueMapper: (HomeCardItemModel sales, _) => sales.y,
        dataLabelSettings: const DataLabelSettings(
          isVisible: false,
        ),
      ),
      ScatterSeries<HomeCardItemModel, String>(
        dataSource: List.generate(
            30, (index) => HomeCardItemModel(x: "$index", y: index.toDouble())),
        xValueMapper: (HomeCardItemModel sales, _) => sales.x,
        yValueMapper: (HomeCardItemModel sales, _) => sales.y,
        markerSettings: const MarkerSettings(
          height: 3,
          width: 3,
        ),
        pointColorMapper: (datum, index) => Colors.red,
        // trackColor: Colors.blue,
        // isTrackVisible: false
      ),
    ];
  }

  List<ColumnSeries<HomeCardItemModel, String>> _getSteps() {
    return <ColumnSeries<HomeCardItemModel, String>>[
      ColumnSeries<HomeCardItemModel, String>(
        dataSource: List.generate(
            30,
            (index) =>
                HomeCardItemModel(x: index.toString(), y: index.toDouble())),
        isTrackVisible: true,
        trackColor: ColorUtils.fromHex("#FF212526"),
        trackBorderWidth: 0,
        borderRadius: BorderRadius.circular(3),
        xValueMapper: (HomeCardItemModel sales, _) => sales.x,
        yValueMapper: (HomeCardItemModel sales, _) => sales.y,
        dataLabelSettings: const DataLabelSettings(
          isVisible: false,
        ),
      )
    ];
  }

  Widget _buildSleep() {
    Widget _buildSleepItem({required double width}) {
      return Container(
        height: 85.w,
        width: width,
        margin: EdgeInsets.only(right: 10.w),
        child: Column(
          children: [
            Expanded(
                child: Container(
              color: Colors.red,
            )),
            Expanded(
                child: Container(
              color: Colors.blue,
            )),
            Expanded(
                child: Container(
              color: Colors.yellow,
            )),
          ],
        ),
      );
    }

    return Container(
      height: 85.w,
      child: ListView.builder(
        itemCount: 30,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return _buildSleepItem(width: Random.secure().nextDouble() * 100);
        },
      ),
    );
  }

  Widget _buildEMOTION() {
    Widget _buildSleepItem({required double width}) {
      return Container(
        height: 85.w,
        width: width,
        margin: EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF212526"),
          borderRadius: BorderRadius.circular(3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Column(
            children: [
              Expanded(
                  flex: 0,
                  child: Container(
                    color: Colors.yellow,
                  )),
              Expanded(
                  child: Container(
                color: Colors.red,
              )),
              Expanded(
                // flex: 0,
                child: Container(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 85.w,
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: ListView.builder(
        itemCount: 48,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return _buildSleepItem(width: 6);
        },
      ),
    );
  }

  List<ChartSeries<HomeCardItemModel, String>> _getHEARTRATE() {
    return <ChartSeries<HomeCardItemModel, String>>[
      SplineAreaSeries<HomeCardItemModel, String>(
        dataSource: List.generate(
            30,
            (index) => HomeCardItemModel(
                x: index.toString(), y: Random.secure().nextInt(1000))),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // mySnTheme.titleColorReverse.withOpacity(0.6),
            Colors.red,
            Colors.transparent
          ],
        ),
        borderWidth: 2,
        xValueMapper: (HomeCardItemModel sales, _) => sales.x,
        yValueMapper: (HomeCardItemModel sales, _) => sales.y,
      ),
    ];
  }

  List<ChartSeries<HomeCardItemModel, String>> _getEMOTION() {
    return <ChartSeries<HomeCardItemModel, String>>[
      StackedColumnSeries<HomeCardItemModel, String>(
        dataSource: List.generate(
            30,
            (index) => HomeCardItemModel(
                  x: "$index",
                  y: 40,
                )),
        isTrackVisible: false,
        spacing: 0,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(3),
          bottomLeft: Radius.circular(3),
        ),
        xValueMapper: (HomeCardItemModel sales, _) => sales.x,
        yValueMapper: (HomeCardItemModel sales, _) => sales.y,
        pointColorMapper: (datum, index) => Colors.red,
        dataLabelSettings: const DataLabelSettings(
          isVisible: false,
        ),
        onPointTap: (pointInteractionDetails) {
          vmPrint(pointInteractionDetails.seriesIndex);
        },
      ),
      StackedColumnSeries<HomeCardItemModel, String>(
        dataSource: List.generate(
            30,
            (index) => HomeCardItemModel(
                  x: "$index",
                  y: 15,
                )),
        isTrackVisible: false,
        spacing: 0,
        borderRadius: BorderRadius.zero,
        xValueMapper: (HomeCardItemModel sales, _) => sales.x,
        yValueMapper: (HomeCardItemModel sales, _) => sales.y,
        pointColorMapper: (datum, index) => Colors.blue,
        dataLabelSettings: const DataLabelSettings(
          isVisible: false,
        ),
        onPointTap: (pointInteractionDetails) {
          vmPrint(pointInteractionDetails.seriesIndex);
        },
      ),
      StackedColumnSeries<HomeCardItemModel, String>(
        dataSource: List.generate(
            30,
            (index) => HomeCardItemModel(
                  x: "$index",
                  y: 100,
                )),
        isTrackVisible: false,
        spacing: 0,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(3),
          topRight: Radius.circular(3),
        ),
        xValueMapper: (HomeCardItemModel sales, _) => sales.x,
        yValueMapper: (HomeCardItemModel sales, _) => sales.y,
        pointColorMapper: (datum, index) => Colors.yellow,
        dataLabelSettings: const DataLabelSettings(
          isVisible: false,
        ),
        onPointTap: (pointInteractionDetails) {
          vmPrint(pointInteractionDetails.seriesIndex);
        },
      ),
    ];
  }
}
