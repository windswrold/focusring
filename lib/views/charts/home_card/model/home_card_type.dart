import 'package:beering/const/constant.dart';

import 'home_card_x.dart';

class KHomeCardModel {
  KHealthDataType? type;
  String? date;
  String? result;
  String? resultDesc;

  String? startDesc;
  String? endDesc;

  int? index;
  bool? state;

  List<List<KChartCellData>>? datas;

  double? maximum;

  KHomeCardModel({
    this.maximum,
    this.date,
    this.result,
    this.resultDesc,
    this.startDesc,
    this.endDesc,
    this.index,
    this.state,
    this.type = KHealthDataType.STEPS,
    this.datas,
  });
}
