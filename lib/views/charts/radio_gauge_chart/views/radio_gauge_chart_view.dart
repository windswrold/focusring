import 'package:flutter/material.dart';
import 'package:focusring/app/modules/home_state/controllers/home_state_controller.dart';
import 'package:focusring/views/charts/radio_gauge_chart/model/radio_gauge_chart_model.dart';

import 'package:get/get.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class RadioGaugeChartView extends StatelessWidget {
  const RadioGaugeChartView({Key? key, required this.datas}) : super(key: key);

  final List<RadioGaugeChartData> datas;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      key: GlobalKey(),
      series: [
        RadialBarSeries<RadioGaugeChartData, String>(
            cornerStyle: CornerStyle.bothCurve,
            gap: '10%',
            radius: '90%',
            dataSource: datas.reversed.toList(),
            xValueMapper: (RadioGaugeChartData data, _) => data.name ?? "",
            yValueMapper: (RadioGaugeChartData data, _) => data.percent,
            trackOpacity: 0.38,
            trackColor: Colors.white38,
            pointColorMapper: (RadioGaugeChartData data, _) => data.color,
            pointRadiusMapper: (RadioGaugeChartData data, _) => "100%",
            dataLabelSettings: const DataLabelSettings(isVisible: false))
      ],
    );
  }
}
