import 'dart:math';

import 'package:decimal/decimal.dart';

import '../../../../public.dart';

class RadioGaugeChartData {
  final String? title;
  final double? current;
  final double? all;
  final Color? color;
  final String? icon;
  final String? symbol;

  RadioGaugeChartData(
      {this.title, this.current, this.color, this.all, this.icon, this.symbol});

  static List<RadioGaugeChartData> getDefaultHeartGaugeData() {
    return KHeartRateStatusType.values
        .map(
          (e) => RadioGaugeChartData(
            title: e.getStatusDesc() + e.getStateCondition(),
            color: e.getStatusColor(),
            all: 0,
            current: 0,
          ),
        )
        .toList();
  }
}
