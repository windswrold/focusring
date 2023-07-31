import 'package:decimal/decimal.dart';
import 'package:focusring/app/data/health_data.dart';

import '../../../../public.dart';

class KChartCellData {
  ///x轴
  dynamic x;

  ///y轴数据 低
  num y;

  ///高
  num z;

  ///平均值
  num a;

  Color? color;
  KSleepStatus? state;

  KChartCellData({
    this.x,
    this.y = 0,
    this.z = 0,
    this.color,
    this.state,
    this.a = 0,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "x $x y $y z $z a $a";
  }

  static KChartCellData generateChartCellData(HealthData data) {
    return KChartCellData();
  }
}
