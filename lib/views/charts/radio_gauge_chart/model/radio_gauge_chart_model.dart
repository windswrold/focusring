import 'package:decimal/decimal.dart';

import '../../../../public.dart';

class RadioGaugeChartData {
  final String? title;
  final int? current;
  final int? all;
  final Color? color;
  final String? icon;
  final String? symbol;

  RadioGaugeChartData(
      {this.title, this.current, this.color, this.all, this.icon, this.symbol});
}
