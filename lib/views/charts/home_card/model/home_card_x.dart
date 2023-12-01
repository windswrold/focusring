import 'package:beering/app/data/health_data_utils.dart';

import '../../../../public.dart';

class KChartCellData {
  ///x轴
  dynamic x;

  ///y轴数据 低
  num yor_low;

  ///高
  num high;

  ///平均值
  num averageNum;

  Color? color;
  KSleepStatusType? state;

  KChartCellData({
    this.x,
    this.yor_low = 0,
    this.high = 0,
    this.color,
    this.state,
    this.averageNum = 0,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "x $x y $yor_low z $high a $averageNum";
  }

  static KChartCellData generateChartCellData(HealthDataUtils data) {
    return KChartCellData();
  }
}
