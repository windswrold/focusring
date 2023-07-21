import 'package:decimal/decimal.dart';

import '../../../../public.dart';

class KChartCellData {
  dynamic x;
  dynamic y;
  dynamic z;
  Color? color;

  KChartCellData({
    this.x,
    this.y,
    this.z,
    this.color,
  });

  static Future<List<KChartCellData>> configPieDataList() async {
    List<KChartCellData> datas = [];

    return datas;
  }
}
