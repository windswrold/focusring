import 'dart:math';

import 'package:decimal/decimal.dart';

import '../../../../public.dart';

class RadioGaugeChartData {
  final String? title;
  final String? currentStr;
  final String? allStr;
  final Color? color;
  final String? icon;
  final String? symbol;

  RadioGaugeChartData(
      {this.title,
      this.currentStr,
      this.color,
      this.allStr,
      this.icon,
      this.symbol});

  static List<RadioGaugeChartData> getDefaultHeartGaugeData() {
    return KHeartRateStatusType.values
        .map(
          (e) => RadioGaugeChartData(
            title: e.getStatusDesc() + e.getStateCondition(),
            color: e.getStatusColor(),
            allStr: "0",
            currentStr: "0",
          ),
        )
        .toList();
  }

  double calPercent() {
    try {
      Decimal c = Decimal.parse(currentStr ?? "0");
      Decimal a = Decimal.parse(allStr ?? "0");
      return getPercent(current: c.toDouble(), all: a.toDouble());
    } catch (e) {
      vmPrint("RadioGaugeChartData err $e");
      return 0;
    }
  }
}
