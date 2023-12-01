import 'package:beering/app/data/health_data_utils.dart';

import '../../../../public.dart';

class KChartCellData {
  ///x轴
  dynamic x;

  ///y轴数据 低
  num y;

  ///高
  num z;

  ///平均值
  num averageNum;

  Color? color;
  KSleepStatusType? state;

  KChartCellData({
    this.x,
    this.y = 0,
    this.z = 0,
    this.color,
    this.state,
    this.averageNum = 0,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "x $x y $y z $z a $averageNum";
  }

  static KChartCellData generateChartCellData(HealthDataUtils data) {
    return KChartCellData();
  }
}
