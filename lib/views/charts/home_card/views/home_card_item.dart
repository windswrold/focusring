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

          _buildChart(),

          _buildFooter(),

          // Container(
          //   height: 85.w,
          //   child: SfCartesianChart(
          //     plotAreaBorderWidth: 0,
          //     backgroundColor: Colors.transparent,
          //     primaryXAxis: CategoryAxis(
          //       isVisible: false,
          //     ),
          //     primaryYAxis: NumericAxis(
          //       isVisible: false,
          //     ),
          //     series: _getTracker(),
          //   ),
          // ),
          // _buildSleep(),

          // Container(
          //   height: 85.w,
          //   child: SfCartesianChart(
          //     plotAreaBorderWidth: 0,
          //     primaryXAxis: CategoryAxis(
          //       isVisible: false,
          //     ),
          //     primaryYAxis: NumericAxis(
          //       isVisible: false,
          //     ),
          //     series: _getSplieAreaSeries([]),
          //   ),
          // ),
          //血氧
          // Container(
          //   height: 85.w,
          //   child: SfCartesianChart(
          //     plotAreaBorderWidth: 0,
          //     primaryXAxis: CategoryAxis(
          //       isVisible: false,
          //     ),
          //     primaryYAxis: NumericAxis(
          //       isVisible: false,
          //     ),
          //     series: _getDefaultScatterSeries(),
          //   ),
          // ),
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

  Widget _buildChart() {
    return Container(
      height: 85.w,
      margin: EdgeInsets.only(top: 18.w),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          isVisible: false,
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
        ),
        series: _getDefaultScatterSeries(),
      ),
    );
  }

  Widget _getHistogram() {
    return SfCartesianChart();
  }

  List<XyDataSeries<HomeCardItemModel, String>> _getDefaultScatterSeries() {
    return <XyDataSeries<HomeCardItemModel, String>>[
      ColumnSeries<HomeCardItemModel, String>(
        dataSource: List.generate(30,
            (index) => HomeCardItemModel(x: index.toString(), y: 0.toDouble())),
        isTrackVisible: true,
        trackColor: ColorUtils.fromHex("#212621"),
        borderRadius: BorderRadius.circular(3),
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

  List<ColumnSeries<HomeCardItemModel, String>> _getTracker() {
    return <ColumnSeries<HomeCardItemModel, String>>[
      ColumnSeries<HomeCardItemModel, String>(
        dataSource: List.generate(
            30,
            (index) =>
                HomeCardItemModel(x: index.toString(), y: index.toDouble())),
        isTrackVisible: true,
        trackColor: ColorUtils.fromHex("#212621"),
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
          return _buildSleepItem(width: 20);
        },
      ),
    );
  }

  List<ChartSeries<HomeCardItemModel, String>> _getSplieAreaSeries(
      List<HomeCardItemModel> chartData) {
    return <ChartSeries<HomeCardItemModel, String>>[
      SplineAreaSeries<HomeCardItemModel, String>(
        dataSource: List.generate(
          30,
          (index) =>
              HomeCardItemModel(x: index.toString(), y: index.toDouble()),
        ),
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
}
