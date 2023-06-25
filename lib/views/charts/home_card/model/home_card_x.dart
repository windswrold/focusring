import 'package:decimal/decimal.dart';

import '../../../../public.dart';

class HomeCardItemModel {
  dynamic x;
  dynamic y;
  Color? color;

  HomeCardItemModel({
    this.x,
    this.y,
    this.color,
  });

  static Future<List<HomeCardItemModel>> configPieDataList() async {
    List<HomeCardItemModel> datas = [];

    return datas;
  }
}
