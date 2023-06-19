import 'package:decimal/decimal.dart';

import '../../../../public.dart';

class RadioGaugeChartData {
  String? name;
  int? percent;
  Color? color;

  RadioGaugeChartData({this.name, this.percent, this.color});

  static Future<List<RadioGaugeChartData>> configPieDataList() async {
    List<RadioGaugeChartData> datas = [];
    List<Color> colorsData = [
      ColorUtils.fromHex("#FF00CEFF"),
      ColorUtils.fromHex("#FFFF903B"),
      ColorUtils.fromHex("#FF34E050"),
      ColorUtils.fromHex("#FF4DE86C"),
    ];

    return datas;
  }
}
